//import 'package:castillo_crud/pages/pages_detalle.dart';
import 'package:castillo_crud/pages/pages_home.dart';
import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ForceGame',
      initialRoute: '/',
      routes: {
        '/'   :(BuildContext context)=>PageHome(),
        //'detalle':(BuildContext context)=>PageDetalle(),
      },
    );
  }
}