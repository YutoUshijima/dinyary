import 'dart:async';
import 'package:flutter/services.dart'; // rootBundleを使うためにimport

import 'package:flutter/material.dart';
import 'header.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // googlemapのflutterにあるパッケージ
import 'package:geolocator/geolocator.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'footer.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io'; // directory型
import 'package:path_provider/path_provider.dart'; // 画像が保存されているローカルファイルを取得するためにimport

import 'NoteViewModel.dart';

class Map_view extends StatelessWidget {
  // <- (※1)
  @override
  Widget build(BuildContext context) { // statelessなヘッダーとボディの部分だけ作成する部分
    return Scaffold(
      appBar: Header(),
      body: MapSample(),
      bottomNavigationBar: Footer(
        pageid: 1),
          );
  }
}



class MapSample extends HookWidget {
  final Completer<GoogleMapController> _mapController = Completer();
  // 初期値の設定。現在地が取得出来ない場合の初期表示位置を百万遍に設定
  final Position _initialPosition = Position(
    latitude: 35.02887415753032,
    longitude: 135.77922493865512,
    timestamp: DateTime.now(),
    altitude: 0,
    accuracy: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
  );

  @override
  Widget build(BuildContext context) {
    // 初期表示座標のMarkerを設定
    final initialMarkers = {
      _initialPosition.timestamp.toString(): Marker(
        markerId: MarkerId(_initialPosition.timestamp.toString()),
        position: LatLng(_initialPosition.latitude, _initialPosition.longitude),
      ),
    };
    // 現在地取得のためのpositionとmakerをhookのuseStateを使って設定
    final position = useState<Position>(_initialPosition);
    final markers = useState<Map<String, Marker>>(initialMarkers);
    // useStateを用いることでデータベースから更新される緯度経度を保持し、更新されると変更されるように設定している
    final markerLocations = useState<List<LatLng>>([]); // markerに渡される緯度経度の数値
    final pinImages = useState<List<BitmapDescriptor>>([]); // markerに渡される画像のbitmap

    _setCurrentLocation(position, markers);
    _animateCamera(position);
    _getTimelineImagePosition(markerLocations, pinImages);


    final Set<Marker> timelineMarker = {}; // マップに表示する画像marker一覧

    // マップに表示するmarkerを作る関数
    Set<Marker> _createMarker() {
      if(markerLocations.value.isNotEmpty){
        // timelineMarker.clear();
        markerLocations.value.asMap().forEach((i, markerLocation) {
          timelineMarker.add(
            Marker(
              markerId: MarkerId("myMarker{$i}"),
              position: markerLocation,
              icon: pinImages.value[i],
            ),
          );
        });
      }
      return timelineMarker;
    }


    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal, // 航空写真などに変更する場合はこの部分をいじる
        myLocationButtonEnabled: false, // GoogleMap の右下に表示される現在地へ移動するボタン
        
        // 初期表示位置は百万遍に設定
        initialCameraPosition: CameraPosition(
          target: LatLng(_initialPosition.latitude, _initialPosition.longitude),
          zoom: 14.4746,
        ),
        onMapCreated: _mapController.complete,
        markers: 
          // markers.value.values.toSet(),
          _createMarker(),
        myLocationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton( //myLocationButtonのカスタマイズ方法がわからなかったので、無理やり現在地へ移動するボタンを作りました
        onPressed: ()async{_animateCamera(position);},
        foregroundColor: Colors.blue,
        backgroundColor:Colors.white,
        child: Icon(Icons.my_location),
      ),
    );
  }



  // 現在地を取得して状態を管理する関数(現在地の更新を定期的・条件的に行う)
  Future<void> _setCurrentLocation(ValueNotifier<Position> position,
      ValueNotifier<Map<String, Marker>> markers) async {
    final currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,); // 位置情報の取得許可をとる

    const decimalPoint = 3;
    // 過去の座標と最新の座標の小数点第三位で切り捨てた値を判定(更新頻度を落とせるようにするため)
    if ((position.value.latitude).toStringAsFixed(decimalPoint) !=
            (currentPosition.latitude).toStringAsFixed(decimalPoint) &&
        (position.value.longitude).toStringAsFixed(decimalPoint) !=
            (currentPosition.longitude).toStringAsFixed(decimalPoint)) {
      // 現在地座標にMarkerを立てる
      final marker = Marker(
        markerId: MarkerId(currentPosition.timestamp.toString()),
        position: LatLng(currentPosition.latitude, currentPosition.longitude),
      );
      markers.value.clear();
      markers.value[currentPosition.timestamp.toString()] = marker;
      // 現在地座標のstateを更新する
      position.value = currentPosition;
    }
  }

  // 現在地のpositionを使ってカメラの位置を変更する関数
  Future<void> _animateCamera(ValueNotifier<Position> position) async {
    final mapController = await _mapController.future;
    // 現在地座標が取得できたらカメラを現在地に移動する
    await mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.value.latitude, position.value.longitude),
      ),
    );
  }

  // TimeLine上に入力されている緯度経度,画像を保持し、更新する関数(makerLocationsとpinImagesにタイムラインで入力された緯度経度、画像を格納している)
  Future<void> _getTimelineImagePosition(ValueNotifier<List<LatLng>> markerLocations, ValueNotifier<List<BitmapDescriptor>> pinImages) async {
    Directory appDocDir = await getApplicationDocumentsDirectory(); // 画像が保存されているローカルパスを得る
    String appDocPath = appDocDir.path;
    final markerData = await NoteViewModel.getImageLatLng(); // id、緯度経度、画像をDBから得る
    const decimalPoint = 3;
    for (dynamic i = 0; i < markerData.length; i++){
      if((markerLocations.value.length < markerData.length)
        )
          {
            markerLocations.value.add(LatLng(double.parse(markerData[i]['lat']), double.parse(markerData[i]['lng'])));
            // 画像をとってくる際にUnit8Listに直した方がサイズ調整などしやすかったため、変換している
      final Uint8List uintData = await imageChangeUint8List('$appDocPath/00${markerData[i]['id']}_00${markerData[i]['img']}_img.png', 100,100);
            pinImages.value.add(BitmapDescriptor.fromBytes(uintData));
          }
      else if(
          ((markerLocations.value[i].latitude).toStringAsFixed(decimalPoint) !=(double.parse(markerData[i]['lat'])).toStringAsFixed(decimalPoint) &&(markerLocations.value[i].longitude).toStringAsFixed(decimalPoint) !=(double.parse(markerData[i]['lng'])).toStringAsFixed(decimalPoint)))
          {
            markerLocations.value[i] = LatLng(double.parse(markerData[i]['lat']), double.parse(markerData[i]['lng']));
            // 画像をとってくる際にUnit8Listに直した方がサイズ調整などしやすかったため、変換している
            final Uint8List uintData = await imageChangeUint8List('$appDocPath/00${markerData[i]['id']}_00${markerData[i]['img']}_img.png', 100,100);
            pinImages.value[i] = BitmapDescriptor.fromBytes(uintData);
          }
    }
    
  }

  // 画像をUnit8Listに変換する関数
  Future<Uint8List> imageChangeUint8List(String path, int height,int width) async {
    //画像のpathを読み込む
    final ByteData byteData = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetHeight: height,
      targetWidth: width,
    );
    final ui.FrameInfo uiFI = await codec.getNextFrame();
    return (await uiFI.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

}