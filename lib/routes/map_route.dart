import 'dart:async';

import 'package:flutter/material.dart';
import 'header.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // googlemapのflutterにあるパッケージ
import 'package:geolocator/geolocator.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'footer.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

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
  // 現在地が取得出来ない場合の初期表示位置を百万遍に設定
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

    _setCurrentLocation(position, markers);
    _animateCamera(position);

    // final Set<Marker> marker = {};
    // final List<LatLng> _markerLocations = [
    //   // Ayala
    //   LatLng(10.318158, 123.904936),
    //   // IT Park
    //   LatLng(10.328352, 123.905714),
    //   LatLng(10.330698, 123.907295),
    //   // SM
    //   LatLng(10.312147, 123.918603),
    //   // Banilad
    //   LatLng(10.340961, 123.913004),
    //   LatLng(35.02887415753032, 135.77922493865512),
    // ];
    
    // Set<Marker> _createMarker() {
    //   _markerLocations.asMap().forEach((i, markerLocation) {
    //     marker.add(
    //       Marker(
    //         markerId: MarkerId('myMarker{$i}'),
    //         position: markerLocation,
    //       ),
    //     );
    //   });

    //   return marker;
    // }
    // BitmapDescriptor markerIcon;

    // Future<Uint8List> imageChangeUint8List(String path, int height,int width) async {
    //   //画像のpathを読み込む
    //   final ByteData byteData = await rootBundle.load(path);
    //   final ui.Codec codec = await ui.instantiateImageCodec(
    //     byteData.buffer.asUint8List(),
    //     //高さ
    //     targetHeight: height,
    //     //幅
    //     targetWidth: width,
    //   );
    //   final ui.FrameInfo uiFI = await codec.getNextFrame();
    //   return (await uiFI.image.toByteData(format: ui.ImageByteFormat.png))
    //       .buffer
    //       .asUint8List();
    // }

    // Future<void> pinMaker() async {
    //   final Uint8List uintData =
    //       await imageChangeUint8List('assets/map_icon.png', 150,150);
    //   this.BitmapDescriptor markerIcon = BitmapDescriptor.fromBytes(uintData);
    // }

    final Set<Marker> marker = {};
    ValueNotifier<List<Map<String, dynamic>>> _memo = useState<List<Map<String, dynamic>>>([]);
    // void _refresh() async {
    //   final markerData = await NoteViewModel.getNotes();
    //   _memo = markerData;
    // }

    List<LatLng> _markerLocations = [
      // Ayala
      LatLng(10.318158, 123.904936),
      // IT Park
      LatLng(10.328352, 123.905714),
      LatLng(10.330698, 123.907295),
      // SM
      LatLng(10.312147, 123.918603),
      // Banilad
      LatLng(10.340961, 123.913004),
      LatLng(35.02887415753032, 135.77922493865512),
      LatLng(34.6657531, 135.5010362),
    ];

    _getTimelinePosition(_markerLocations);

    Set<Marker> _createMarker() {
      // _refresh();
        _markerLocations.asMap().forEach((i, markerLocation) {
          marker.add(
            Marker(
              markerId: MarkerId("myMarker{$i}"),
              position: markerLocation,
              // icon:
            ),
          );
        });
      return marker;
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
          Set.from(_createMarker(),
          ),
      ),
      floatingActionButton: FloatingActionButton( //myLocationButtonのカスタマイズ方法がわからなかったので、無理やり現在地へ移動するボタンを作りました
        onPressed: ()async{_animateCamera(position);},
        foregroundColor: Colors.blue,
        backgroundColor:Colors.white,
        child: Icon(Icons.my_location),
      ),
    );
  }



  // 現在地を取得して状態を管理する
  Future<void> _setCurrentLocation(ValueNotifier<Position> position,
      ValueNotifier<Map<String, Marker>> markers) async {
    final currentPosition = await Geolocator.getCurrentPosition( // 位置情報の取得許可をとる
      desiredAccuracy: LocationAccuracy.high,
    );

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

  Future<void> _animateCamera(ValueNotifier<Position> position) async {
    final mapController = await _mapController.future;
    // 現在地座標が取得できたらカメラを現在地に移動する
    await mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.value.latitude, position.value.longitude),
      ),
    );
  }

  Future<void> _getTimelinePosition(List<LatLng> markerLocations) async {
    markerLocations.add(LatLng(35.3606255, 138.7273634));
    markerLocations.add(LatLng(35.00, 138.00));
    final markerData = await NoteViewModel.getNotes();
    for (dynamic i = 0; i < markerData.length; i++){
      markerLocations.add(LatLng(double.parse(markerData[i]['lat']), double.parse(markerData[i]['lng'])));
      markerLocations.add(LatLng(35.00, 135.0));
    }
  }

}