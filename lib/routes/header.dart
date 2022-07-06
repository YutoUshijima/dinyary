import 'package:dinyary/routes/timeline_route.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.account_circle),
      ),
      // ignore: prefer_const_literals_to_create_immutables
      actions: [
        //Padding(
        //    padding: const EdgeInsets.all(8.0),
        //    child: IconButton(
        //      icon: const Icon(Icons.create_outlined),
        //      onPressed: () {
        //        Navigator.push(context, MaterialPageRoute(builder: (context) {
        //          return TimeLine();
        //        }));
        //      },
        //    )),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.settings),
        ),
      ],
      title: const Text(
        'diNyary',
      ),
      backgroundColor: Colors.black87,
      centerTitle: true,
      elevation: 0.0,
    );
  }
}
