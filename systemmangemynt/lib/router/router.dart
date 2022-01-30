// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:systemmangemynt/page/addprouduct.dart';
import 'package:systemmangemynt/page/export.dart';
import 'package:systemmangemynt/page/list_of_product.dart';

class Routers extends StatelessWidget {
  const Routers({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(context) => ListOfProduct(),
        '/addProduct':(context) => AddProudct(),
        '/export':(context) => exportPage(),
        '/editProduct':(context) => ListOfProduct()
      },
      
    );
  }
}