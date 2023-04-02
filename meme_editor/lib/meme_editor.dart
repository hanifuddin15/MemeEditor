// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:meme_editor/model/memejsonmodel.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:async';

import 'package:path_provider/path_provider.dart';

class MemeEditor extends StatefulWidget {
  const MemeEditor({super.key, required this.meme});
  final Meme meme;
  @override
  State<MemeEditor> createState() => _MemeEditor();
}

class _MemeEditor extends State<MemeEditor> {
  File? _croppedImage;

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
             SizedBox(height: MediaQuery.of(context).size.width * 0.10),
            Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                Expanded(
                  child: ElevatedButton(
                    style:  ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
                    onPressed: () {},
                    child: const Text('Crop'),
                  ),
                ),
                 SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
                    onPressed: () {},
                    child: const Text('Rotate'),
                  ),
                ),
                 SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                Expanded(
                  child: ElevatedButton(
                    style:  ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
                    onPressed: () {

                      _saveNetworkImage();
                    },
                    child: const Text('Save'),
                  ),
                ),
                 SizedBox(width: MediaQuery.of(context).size.width * 0.05),
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
