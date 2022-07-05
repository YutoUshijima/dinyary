import 'package:flutter/material.dart';
import 'analysis2_route.dart';
import 'header.dart';

const kColorPurple = Color(0xFF8337EC);
const kColorPink = Color(0xFFFF006F);
const kColorIndicatorBegin = kColorPink;
const kColorIndicatorEnd = kColorPurple;
const kColorTitle = Color(0xFF616161);
const kColorText = Color(0xFF9E9E9E);
const kElevation = 4.0;

class Analysis extends StatelessWidget {
  // <- (※1)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                '　　　　　　18・・21・・0 ・・3 ・・6 ・・9 ・・12・・15・・',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )),
        backgroundColor: Colors.black87,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView(children: <Widget>[
            Center(child: OptimizerButtons()),
            ListTile(
              leading: Text("7/1\n(金)", style: TextStyle(fontSize: 15)),
              subtitle: _Body(8, 21),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black,
            ),
            ListTile(
              leading: Text("7/2\n(土)", style: TextStyle(fontSize: 15)),
              subtitle: _Body(6, 30),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black,
            ),
            ListTile(
              leading: Text("7/3\n(日)", style: TextStyle(fontSize: 15)),
              subtitle: _Body(4, 10),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black,
            ),
            ListTile(
              leading: Text("7/4\n(月)", style: TextStyle(fontSize: 15)),
              subtitle: _Body(8, 17),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black,
            ),
            ListTile(
              leading: Text("7/5\n(火)", style: TextStyle(fontSize: 15)),
              subtitle: _Body(2, 15),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black,
            ),
            ListTile(
              leading: Text("7/6\n(水)", style: TextStyle(fontSize: 15)),
              subtitle: _Body(4, 10),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black,
            ),
            ListTile(
              leading: Text("7/7\n(木)", style: TextStyle(fontSize: 15)),
              subtitle: _Body(4, 10),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black,
            ),
            ListTile(
              title: Text("7/3"),
              subtitle: _Body(5, 30),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black,
            ),
            ListTile(
              title: Text("7/4"),
              subtitle: _Body(11, 25),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black,
            ),
            ListTile(
              title: Text("7/5"),
              subtitle: _Body(8, 21),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black,
            ),
            ListTile(
              title: Text("7/6"),
              subtitle: _Body(5, 30),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black,
            ),
            ListTile(
              title: Text("7/7"),
              subtitle: _Body(11, 25),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black,
            ),
          ])
          // child: Column(
          //   children: [
          //     OptimizerButtons(),
          //     PostList(),
          //     // BarChart(
          //       // BarChartData(
          //       //   borderData: FlBorderData(
          //       //       border: const Border(
          //       //         top: BorderSide.none,
          //       //         right: BorderSide.none,
          //       //         left: BorderSide(width: 1),
          //       //         bottom: BorderSide(width: 1),
          //       //       )),
          //       //     groupsSpace: 4,
          //       //     barGroups: [
          //       //       BarChartGroupData(x: 1, barRods: [
          //       //         BarChartRodData(toY: 10, width: 15),
          //       //       ]),
          //       //       BarChartGroupData(x: 2, barRods: [
          //       //         BarChartRodData(toY: 10, width: 15),
          //       //       ]),
          //       //       BarChartGroupData(x: 3, barRods: [
          //       //         BarChartRodData(toY: 10, width: 15),
          //       //       ]),
          //       //       BarChartGroupData(x: 4, barRods: [
          //       //         BarChartRodData(toY: 21, width: 15),
          //       //       ]),
          //       //     ]),
          //       // )
          //   ]
          // )
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

class _PostsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ListTile(
            leading: ClipOval(
              child: Container(
                color: Colors.grey[300],
                width: 48,
                height: 48,
                child: Icon(
                  Icons.storage,
                  color: Colors.grey[800],
                ),
              ),
            ),
            title: Text('Posts'),
            subtitle: Text('20 Posts'),
          ),
        ),
        Expanded(
          flex: 1,
          child: ListTile(
            leading: ClipOval(
              child: Container(
                color: Colors.grey[300],
                width: 48,
                height: 48,
                child: Icon(
                  Icons.style,
                  color: Colors.grey[800],
                ),
              ),
            ),
            title: Text('All Types'),
            subtitle: Text(''),
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  double start_time = 1;
  double end_time = 1;
  _Body(this.start_time, this.end_time);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        width: 400,
        height: 75,
        child: CustomPaint(
          painter: _SamplePainter(start_time, end_time),
        ),
      ),
    ]);
  }
}

class _SamplePainter extends CustomPainter {
  double start_time = 1;
  double end_time = 1;
  _SamplePainter(this.start_time, this.end_time);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey;
    paint.strokeWidth = 4;
    for (int i = 0; i < 48; i++) {
      if (start_time <= i && i <= end_time) {
        paint.color = Colors.red;
      } else {
        paint.color = Colors.grey;
      }
      // if (i % 6 == 0) {
      //   paint.color = Colors.blue;
      // }
      double x = i * 5.9;
      canvas.drawLine(Offset(x, 10), Offset(x, 60), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

