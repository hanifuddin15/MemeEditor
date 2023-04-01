// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meme_editor/model/memejsonmodel.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MemeList extends StatefulWidget {
  const MemeList({super.key});

  @override
  State<MemeList> createState() => _MemeList();
}

class _MemeList extends State<MemeList> {
  List<Meme> memes = [];

  Future<List<Meme>> _fetchMemes() async {
    final response =
        await http.get(Uri.parse('https://api.imgflip.com/get_memes'));
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
        body: memes.isNotEmpty
            ? MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemBuilder: (context, index) {
                  return getWidget(memes[index]);
                },
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  Widget getWidget(Meme memeItem) {
    return Card(
      elevation: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: GestureDetector(
          onTap: () {},
          child: Container(
              color: const Color(0xFFFFFFFF),
              child: Column(
                children: [
                  Center(
                    child: Image.network(
                      memeItem.url,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(memeItem.name,
                          style: const TextStyle(
                              color: Color.fromRGBO(102, 119, 139, 1.0),
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
