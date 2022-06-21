import 'package:flutter/material.dart';

class Header extends StatelessWidget with PreferredSizeWidget{
 @override
 Size get preferredSize => Size.fromHeight(kToolbarHeight);

 @override
 Widget build(BuildContext context) {
   return AppBar(
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
     backgroundColor: Colors.black87,
     centerTitle: true,
     elevation: 0.0,
   );
 }
}