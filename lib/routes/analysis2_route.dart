import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'NoteViewModel.dart';
import 'header.dart';
import 'analysis_route.dart';

const kColorPurple = Color(0xFF8337EC);
const kColorPink = Color(0xFFFF006F);
const kColorIndicatorBegin = kColorPink;
const kColorIndicatorEnd = kColorPurple;
const kColorTitle = Color(0xFF616161);
const kColorText = Color(0xFF9E9E9E);
const kElevation = 4.0;

class Analysis2 extends StatefulWidget {
  const Analysis2({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum Menu { edit, delete }

class _HomePageState extends State{
  List<Map<String, dynamic>> _memo = [];
  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await NoteViewModel.getNotes();
    setState(() {
      _memo = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    var getUpTimeIterable = _memo.where((element) => element['tag']=='Get up');
    var getUpTimeList = [];
    for(var i in getUpTimeIterable){
      getUpTimeList.add(i);
    }
    var sleepTimeIterable = _memo.where((element) => element['tag']=='Going to bed');
    var sleepTimeList = [];
    for(var i in sleepTimeIterable){
      sleepTimeList.add(i);
    }
    print(getUpTimeList);
    print(sleepTimeList);
    return Scaffold(
      appBar: Header(),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: getUpTimeList.length,
        itemBuilder: (context, index) {
          String a = getUpTimeList[index]['createdAt'];
          String b = sleepTimeList[index]['createdAt'];
          DateTime getUpTime = DateTime.parse(a);
          DateTime sleepTime = DateTime.parse(b);

          print('getuptime');
          print(getUpTime);

          for(var i in sleepTimeList){
            String c = i['createdAt'];
            DateTime sleepTime2 = DateTime.parse(c);
            print('sleeptime');
            print(sleepTime2);
            if(sleepTime2.difference(getUpTime).inHours>=0){
              print('for');
              print(sleepTime2.difference(getUpTime));
            }else{
              print('else');
            }


          }

          return Text('Get Up at:'+a+'¥n Sleeping at:'+b);
        },// return Text(_memo[index]['tag']=="Get up"?"Get Up at :"+_memo[index]['createdAt']:a);
      ),
    );
  }
}