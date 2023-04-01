// ignore_for_file: prefer_const_constructors



import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meme_editor/model/memejsonmodel.dart';
import 'dart:convert';
import 'dart:async';

// import 'package:movielist/movielistitem.dart';


class MemeList extends StatefulWidget {
  const MemeList({super.key});

  @override
  State<MemeList> createState() => _MemeList();
}

class _MemeList extends State<MemeList> {
  List<Meme> memes = [];

  Future<List<Meme>> _fetchMemes() async {
    final response = await http.get(Uri.parse('https://api.imgflip.com/get_memes'));
    final data = jsonDecode(response.body);
    final memeJsonModel = MemeJsonModel.fromJson(data);
    return memeJsonModel.data.memes;
  }
  
  @override
  void initState() {
    super.initState();
    _fetchMemes().then((value) {
      setState(() {
        memes = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(35, 47, 59, 1.0),
        appBar: AppBar(
          elevation: 0.0,
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                Color.fromRGBO(24, 209, 115, 1.0),
                Color.fromRGBO(35, 47, 59, 1.0)
              ]))),
          title: const Text('Meme List', style: TextStyle(color: Colors.white)),
          leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView.builder(
        itemCount: memes.length,
        itemBuilder: (BuildContext context, int index) {
          final meme = memes[index];
          return ListTile(
            leading: Image.network(meme.url),
            title: Text(meme.name),
          );
        },
      ),
    )
      
      
    );
  }
}
