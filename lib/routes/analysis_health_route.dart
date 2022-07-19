import 'package:flutter/material.dart';

import 'header.dart';
import 'footer.dart';
import 'analysis_route.dart';

import 'dart:async';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';


class AnalysisHealth extends StatefulWidget {
  const AnalysisHealth({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}

class _HomePageState extends State{
  List<HealthDataPoint> _healthDataList = [];
  List<HealthDataPoint> _healthDataListSteps = [];
  List<HealthDataPoint> _healthDataListDistance = [];
  AppState _stateSteps = AppState.DATA_NOT_FETCHED;
  AppState _stateDistance = AppState.DATA_NOT_FETCHED;

  int steps = 0;
  double distance = 0;
  var distanceString = "";

  @override
  void initState() {
    super.initState();
  }

  Future fetchData() async {
    steps = 0;
    distance = 0;
    /// Get everything from midnight until now
    DateTime endDate = DateTime.now();
    DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day);

    HealthFactory health = HealthFactory();

    /// Define the types to get.
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.DISTANCE_WALKING_RUNNING,
    ];

    List<HealthDataType> typesSteps = [HealthDataType.STEPS];

    List<HealthDataType> typesDistance = [HealthDataType.DISTANCE_WALKING_RUNNING];

    setState(() => _stateSteps = _stateDistance = AppState.FETCHING_DATA);

    /// You MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);

    if (accessWasGranted) {
      try {
        /// Fetch new data
        List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(startDate, endDate, types);
        List<HealthDataPoint> healthDataSteps =
        await health.getHealthDataFromTypes(startDate, endDate, typesSteps);
        List<HealthDataPoint> healthDataDistance =
        await health.getHealthDataFromTypes(startDate, endDate, typesDistance);

        /// Save all the new data points
        _healthDataList.addAll(healthData);
        _healthDataListSteps.addAll(healthDataSteps);
        _healthDataListDistance.addAll(healthDataDistance);
      } catch (e) {
        print("Caught exception in getHealthDataFromTypes: $e");
      }

      /// Filter out duplicates
      _healthDataListSteps = HealthFactory.removeDuplicates(_healthDataListSteps);
      _healthDataListDistance = HealthFactory.removeDuplicates(_healthDataListDistance);

      /// Print the results
      _healthDataListSteps.forEach((x) {
        // print("Data point: $x");
        steps += ((x.value as NumericHealthValue).numericValue).toInt();
      });

      _healthDataListDistance.forEach((x) {
        // print("Data point: $x");
        distance += ((x.value as NumericHealthValue).numericValue).toDouble();
      });
      distanceString= (distance/1000).toStringAsFixed(2);

      var date = [];
      _healthDataList.forEach((x) {
        date.add(x.dateFrom.day);
      });
      date = date.toSet().toList();

      /// Update the UI to display the results
      setState(() {
        _stateSteps=
        _healthDataListSteps.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
      setState(() {
        _stateDistance =
        _healthDataListDistance.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
    } else {
      print("Authorization not granted");
      setState(() => _stateSteps = _stateDistance = AppState.AUTH_NOT_GRANTED);
    }
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 10,
            )),
        Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReadySteps() {
    return ListView.builder(
        itemCount: _healthDataListSteps.length,
        itemBuilder: (_, index) {
          HealthDataPoint p = _healthDataListSteps[index];
          return ListTile(
            title: Text("歩数: ${(p.value as NumericHealthValue).numericValue.toInt()}歩"),
            // trailing: Text('${p.unitString}'),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        });
  }

  Widget _contentDataReadyDistance() {
    return ListView.builder(
        itemCount: _healthDataListDistance.length,
        itemBuilder: (_, index) {
          HealthDataPoint p = _healthDataListDistance[index];
          return ListTile(
            title: Text("歩行距離: ${(p.value as NumericHealthValue).numericValue.toDouble()/1000} km"),
            // trailing: Text('${p.unitString}'),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        });
  }

  Widget _contentNoData() {
    return Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return Text('Press the download button to fetch data');
  }

  Widget _authorizationNotGranted() {
    return Text('''Authorization not given.
        For Android please check your OAUTH2 client ID is correct in Google Developer Console.
         For iOS check your permissions in Apple Health.''');
  }

  Widget _content(int x) {
    if (x==0){
      if (_stateSteps == AppState.DATA_READY) {
        return _contentDataReadySteps();
      } else if (_stateSteps == AppState.NO_DATA) {
        return _contentNoData();
      } else if (_stateSteps == AppState.FETCHING_DATA) {
        return _contentFetchingData();
      } else if (_stateSteps == AppState.AUTH_NOT_GRANTED) {
        return _authorizationNotGranted();
      }
    }else{
      if (_stateDistance == AppState.DATA_READY) {
        return _contentDataReadyDistance();
      } else if (_stateDistance == AppState.NO_DATA) {
        return _contentNoData();
      } else if (_stateDistance == AppState.FETCHING_DATA) {
        return _contentFetchingData();
      } else if (_stateDistance == AppState.AUTH_NOT_GRANTED) {
        return _authorizationNotGranted();
      }
    }
    return _contentNotFetched();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(),
        body: Column(
          children: [
            Center(child: OptimizerButtons()),
            Text("歩数 : 計 $steps 歩", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Flexible(
              child: Center(
                child: _content(0),
              ),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black,
            ),
            Text("歩行距離 :　計 $distanceString km", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Flexible(
              child: Center(
                child: _content(1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () async {
                  await Permission.activityRecognition.request().isGranted;
                  await fetchData();
                },
                child: Text("download"),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Footer(pageid: 3),
    );
  }
}

class _OptimizerButton extends StatelessWidget {
  final String text;

  const _OptimizerButton({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Analysis()),
        );
      },
      child: Text(
        text,
        style: TextStyle(color: kColorTitle, fontSize: 12),
      ),
    );
  }
}

class OptimizerButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: _OptimizerButton(text: '睡眠管理'),
      ),
    );
  }
}