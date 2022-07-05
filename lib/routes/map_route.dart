import 'dart:async';

import 'package:flutter/material.dart';
import 'header.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // googlemapのflutterにあるパッケージ
import 'package:geolocator/geolocator.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Map_view extends StatelessWidget {
  // <- (※1)
  @override
  Widget build(BuildContext context) { // statelessなヘッダーとボディの部分だけ作成する部分
    return Scaffold(
      appBar: Header(),
      body: MapSample(),
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

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal, // 航空写真などに変更する場合はこの部分をいじる
        myLocationButtonEnabled: true, // GoogleMap の右下に表示される現在地へ移動するボタン
        // 初期表示位置は百万遍に設定
        initialCameraPosition: CameraPosition(
          target: LatLng(_initialPosition.latitude, _initialPosition.longitude),
          zoom: 14.4746,
        ),
        onMapCreated: _mapController.complete,
        markers: markers.value.values.toSet(),
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
}