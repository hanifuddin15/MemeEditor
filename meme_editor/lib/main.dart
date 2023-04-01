import 'package:flutter/material.dart';
import 'package:meme_editor/memelist.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  //change

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MemeList(),   //type your page name here
      debugShowCheckedModeBanner: false,
    );
  }
}