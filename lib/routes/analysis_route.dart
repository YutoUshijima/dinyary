import 'package:flutter/material.dart';
import 'analysis2_route.dart';
import 'NoteViewModel.dart';
import 'header.dart';
import 'footer.dart';

const kColorTitle = Color(0xFF616161);

class Analysis extends StatefulWidget {
  const Analysis({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State{
  List<Map<String, dynamic>> _memo = [];
  bool _isLoading = true;

  var sleepList = [];
  var morningList = [];
  var dayList = [];
  var weekday = [];

  void _refreshJournals() async {
    final data = await NoteViewModel.getNotes();
    setState(() {
      _memo = data;
      _isLoading = false;

      weekday = ['(月)', '(月)', '(火)', '(水)', '(木)', '(金)', '(土)', '(日)'];

      // var sleepList = [];
      sleepList.add(DateTime(2022,7,6,3,20));
      sleepList.add(DateTime(2022,7,6,22,33));
      sleepList.add(DateTime(2022,7,7,23));
      sleepList.add(DateTime(2022,7,8,20));
      sleepList.add(DateTime(2022,7,9,3,20));
      sleepList.add(DateTime(2022,7,9,22,33));
      sleepList.add(DateTime(2022,7,10,23));
      sleepList.add(DateTime(2022,7,11,20));
      sleepList.add(DateTime(2022,7,12,3,20));
      sleepList.add(DateTime(2022,7,12,22,33));
      sleepList.add(DateTime(2022,7,13,23));
      sleepList.add(DateTime(2022,7,14,20));

      // var morningList = [];
      morningList.add(DateTime(2022,7,6,10));
      morningList.add(DateTime(2022,7,7,6,30));
      morningList.add(DateTime(2022,7,8,20,22));
      morningList.add(DateTime(2022,7,9,10));
      morningList.add(DateTime(2022,7,10,6,30));
      morningList.add(DateTime(2022,7,11,20,22));
      morningList.add(DateTime(2022,7,12,10));
      morningList.add(DateTime(2022,7,13,6,30));
      morningList.add(DateTime(2022,7,14,20,22));


      // var dayList = [];
      for(var i in sleepList + morningList){
        dayList.add(DateTime(i.year, i.month, i.day));
      }
      dayList = dayList.toSet().toList();

      for(var i in dayList){
        print('======================================');
        print(i);
        var sleep = [];
        var morning = [];
        for(var i2 in sleepList){
          if(i.year==i2.year && i.month==i2.month && i.day==i2.day){
            sleep.add(i2);
          }
          // print(i.add(Duration(days: 1)));
          // print(i2);
          // print((i.add(Duration(days: 1))).isBefore(i2));
          if((i.add(Duration(days: 1))).isBefore(i2)){
            break;
          }
        }

        for(var i2 in morningList){
          if(i.year==i2.year && i.month==i2.month && i.day==i2.day){
            morning.add(i2);
          }
          // print(i.add(Duration(days: 1)));
          // print(i2);
          // print((i.add(Duration(days: 1))).isBefore(i2));
          if((i.add(Duration(days: 1))).isBefore(i2)){
            break;
          }
        }
        print(sleep);
        print(morning);
        print('-----------------');


        var memori = [0,0,1,0,2,0,3,0,4,0,5,0,6,0,7,0,8,0,9,0,10,0,11,0,12,0,13,0,14,0,15,0,16,0,17,0,18,0,19,0,20,0,21,0,22,0,23,0];
        var graph = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
        var end = 48;

        if(sleep.isEmpty){
          if(morning.isEmpty){
            print('double_null');
          }else{
            print('sleep_null');
            end = morning[morning.length-1].hour*2 + morning[morning.length-1].minute~/30;
            for(var l=0; l<end; l++){
              graph[l] = 1;
            }
          }
        }else{
          if(morning.isNotEmpty){
            print('not_null');
            if(sleep[0].isAfter(morning[0])){
              sleep.insert(0, i);
              print('new_sleep');
              print(sleep);
            }

            for(var j in sleep){
              end = 48;
              for(var k in morning){
                if(j.isBefore(k)){
                  end = k.hour * 2 + k.minute~/30;
                  print('end = k.hour * 2 + k.minute~/30');
                  print(end);
                  break;
                }
              }
              print('j.hour*2+j.minute~/30');
              print(j.hour*2+j.minute~/30);
              for(var l=j.hour*2+j.minute~/30; l<end; l++){
                graph[l] = 1;
              }
            }
          }else{
            print('morning_null');
            for(var j in sleep){
              print('j.hour*2+j.minute~/30');
              print(j.hour*2+j.minute~/30);
              for(var l=j.hour*2+j.minute~/30; l<end; l++){
                graph[l] = 1;
              }
            }
          }
        }
        print(memori);
        print(graph);
      }

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
      bottomNavigationBar: Footer(
        pageid: 3),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.account_circle),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.create_outlined),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.settings),
          ),
        ],
        title: Text(
          'diNyary',
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(14.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                '　　　　　　0 ・・3 ・・6 ・・9 ・・12・・15・・18・・21・・',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )),
        backgroundColor: Colors.black87,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
      //     : ListView.builder(
      //   itemCount: getUpTimeList.length,
      //   itemBuilder: (context, index) {
      //     String a = getUpTimeList[index]['createdAt'];
      //     String b = sleepTimeList[index]['createdAt'];
      //     DateTime getUpTime = DateTime.parse(a);
      //     DateTime sleepTime = DateTime.parse(b);
      //
      //
      //     for(var i in sleepTimeList){
      //       String c = i['createdAt'];
      //       DateTime sleepTime2 = DateTime.parse(c);
      //       print('sleeptime');
      //       print(sleepTime2);
      //       if(sleepTime2.difference(getUpTime).inHours>=0){
      //         print('for');
      //       }else{
      //         print('else');
      //       }
      //
      //     }
      //     return Text('Get Up at:'+a+'¥n Sleeping at:'+b);
      //   },// return Text(_memo[index]['tag']=="Get up"?"Get Up at :"+_memo[index]['createdAt']:a);
      // ),

          : ListView(children: [
        Center(child: OptimizerButtons()),
        Flexible(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: dayList.length,
            itemBuilder: (context, index) {
              print('======================================');
              var day = dayList[index];
              print('day');
              print(day);

              var sleep = [];
              var morning = [];
              for(var i2 in sleepList){
                if(day.year==i2.year && day.month==i2.month && day.day==i2.day){
                  sleep.add(i2);
                }
                // print(i.add(Duration(days: 1)));
                // print(i2);
                // print((i.add(Duration(days: 1))).isBefore(i2));
                if((day.add(Duration(days: 1))).isBefore(i2)){
                  break;
                }
              }
              for(var i2 in morningList){
                if(day.year==i2.year && day.month==i2.month && day.day==i2.day){
                  morning.add(i2);
                }
                // print(i.add(Duration(days: 1)));
                // print(i2);
                // print((i.add(Duration(days: 1))).isBefore(i2));
                if((day.add(Duration(days: 1))).isBefore(i2)){
                  break;
                }
              }
              print(sleep);
              print(morning);
              print('-----------------');


              var memori = [0,0,1,0,2,0,3,0,4,0,5,0,6,0,7,0,8,0,9,0,10,0,11,0,12,0,13,0,14,0,15,0,16,0,17,0,18,0,19,0,20,0,21,0,22,0,23,0];
              var graph = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
              var end = 48;

              if(sleep.isEmpty){
                if(morning.isEmpty){
                  print('double_null');
                }else{
                  print('sleep_null');
                  end = morning[morning.length-1].hour*2 + morning[morning.length-1].minute~/30;
                  for(var l=0; l<end; l++){
                    graph[l] = 1;
                  }
                }
              }else{
                if(morning.isNotEmpty){
                  print('not_null');
                  if(sleep[0].isAfter(morning[0])){
                    sleep.insert(0, day);
                    print('new_sleep');
                    print(sleep);
                  }

                  for(var j in sleep){
                    end = 48;
                    for(var k in morning){
                      if(j.isBefore(k)){
                        end = k.hour * 2 + k.minute~/30;
                        print('end = k.hour * 2 + k.minute~/30');
                        print(end);
                        break;
                      }
                    }
                    print('j.hour*2+j.minute~/30');
                    print(j.hour*2+j.minute~/30);
                    for(var l=j.hour*2+j.minute~/30; l<end; l++){
                      graph[l] = 1;
                    }
                  }
                }else{
                  print('morning_null');
                  for(var j in sleep){
                    print('j.hour*2+j.minute~/30');
                    print(j.hour*2+j.minute~/30);
                    for(var l=j.hour*2+j.minute~/30; l<end; l++){
                      graph[l] = 1;
                    }
                  }
                }
              }
              print(memori);
              print(graph);
              return Column(
                children: [
                  ListTile(
                    leading: Text(day.month.toString()+'/'+day.day.toString()+'\n'+weekday[day.weekday], style: TextStyle(fontSize: 16)),
                    subtitle: _Body(graph),
                  ),
                  Divider(
                    height: 2,
                    thickness: 1,
                    color: Colors.black,
                  ),
                ],
              );
            },
          ),
        ),
      ],
      ),
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
          MaterialPageRoute(builder: (context) => Analysis2()),
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
        child: Row(
          children: [
            SizedBox(width: 16),
            _OptimizerButton(text: '日'),
            SizedBox(width: 16),
            _OptimizerButton(text: '週'),
            SizedBox(width: 16),
            _OptimizerButton(text: '月'),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  List graph;
  _Body(this.graph);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        width: 400,
        height: 75,
        child: CustomPaint(
          painter: _SamplePainter(graph),
        ),
      ),
    ]);
  }
}

class _SamplePainter extends CustomPainter {
  List graph;
  _SamplePainter(this.graph);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey;
    paint.strokeWidth = 4;
    for (int i = 0; i < graph.length; i++) {
      if (graph[i]==0) {
        paint.color = Colors.grey;
      } else {
        paint.color = Colors.red;
      }
      // if(i%6==0){
      //   paint.color = Colors.blue;
      // }
      double x = i * 5.9 + 5;
      canvas.drawLine(Offset(x, 10), Offset(x, 60), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

