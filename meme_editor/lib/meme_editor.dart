// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:meme_editor/model/memejsonmodel.dart';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

class MemeEditor extends StatefulWidget {
  const MemeEditor({super.key, required this.meme});
  final Meme meme;
  @override
  State<MemeEditor> createState() => _MemeEditor();
}

class _MemeEditor extends State<MemeEditor> {
  @override
  void initState() {
    super.initState();
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
            title: const Text('Meme Editor',
                style: TextStyle(color: Colors.white)),
            leading: GestureDetector(
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            )),
        body: Column(
         
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Image.network(
                  widget.meme.url,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Center(
                child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      // backgroundColor: const Colors.red,
                      ),
                  onPressed: () {},
                  child: const Text('Crop'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      // backgroundColor: const Colors.red,
                      ),
                  onPressed: () {},
                  child: const Text('Rotate'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      // backgroundColor: const Colors.red,
                      ),
                  onPressed: () {

                    _saveNetworkImage();
                  },
                  child: const Text('Save'),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  void _saveNetworkImage() async {
    String url =  widget.meme.url;
    final tempDir = await getTemporaryDirectory();
    final path  = '${tempDir.path}/Image.jpg';
    await Dio().download(url, path);
   await  GallerySaver.saveImage(path).then((success) {
      setState(() {
        if (success == true) {
          const snackBar = SnackBar(
            content: Text('Meme Saved'),
          );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          const snackBar = SnackBar(
            content: Text('Meme Coudldnot Saved'),
          );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        print('Image is saved');
      });
    });
  }
}
