// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:systemmangemynt/router/router.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();

  runApp(MaterialApp(
    home: Routers(),
  ));
}
