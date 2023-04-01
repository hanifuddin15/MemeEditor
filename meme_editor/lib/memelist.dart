// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meme_editor/meme_editor.dart';
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
  List<Meme> memesfilter = [];
  TextEditingController controller = TextEditingController();

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
        memesfilter = value;
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
          leading: GestureDetector(),
        ),
        body: Column(
          children: [
            Container(
              height: 50,
              child: CupertinoSearchTextField(
                controller: controller,
                onChanged: (String value) {
                  List<Meme> tempList = [];
                  for (int i = 0; i < memesfilter.length; i++) {
                    var memesearch = memesfilter[i];
                    if (memesearch.name.contains(value)) {
                      tempList.add(memesearch);
                    }
                  }
                  setState(() {
                    memes = tempList;
                  });
                  print('The text has changed to: $value');
                },
                onSubmitted: (String value) {
                  print('Submitted text: $value');
                },
              ),
            ),
            Expanded(
              child: memes.isNotEmpty
                  ? MasonryGridView.count(
                      itemCount: memes.length,
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return getWidget(memes[index]);
                      },
                    )
                  : CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getWidget(Meme memeItem) {
    return Card(
      elevation: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  MemeEditor(meme: memeItem)),
  );
          },
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
