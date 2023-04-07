// ignore_for_file: prefer_const_constructors
//Meme_Editor
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
                  child:
                  // Image.network(
                  //   widget.meme.url,
                  //   fit: BoxFit.fill,
                  // )
                  CachedNetworkImage(
    imageUrl: widget.meme.url,
    placeholder: (context, url) => CircularProgressIndicator(),
    errorWidget: (context, url, error) => Icon(Icons.error),
    cacheManager: CacheManager(
        Config(
          "fluttercampus",
          stalePeriod: const Duration(days: 7),
          //one week cache period
        )
    ),
)
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
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        String tempImage = widget.meme.url ;
                       _croppedImage(tempImage);
                       
                       
                      },
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
                      onPressed: () {
                        
                      int  suba= 10;
                      int subb=39;
                      var result= subtract(suba, subb);
                        print(result);
                      },
                      child: const Text('Rotate'),
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
                      onPressed: () {
                         _saveNetworkImage();
                      },
                      child: const Text('Save'),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNetworkImage() async {
    String url = widget.meme.url;
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/Image.jpg';
    await Dio().download(url, path);
    await GallerySaver.saveImage(path).then((success) {
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
 int subtract(int a,int b){
  
  int minus= a-b;
  // print(sum);
  return minus;
 }

  Future<Null> _croppedImage(String imageUrl) async {
// final String fileName = 'Image/IMG_20210913_164405.jpg'; // Replace with your image file name
// final ByteData data = await rootBundle.load('assets/$fileName');
// final Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
// final String filePath = '${appDocumentsDirectory.path}/$fileName';
// final File file = File(filePath);
// await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
// final String absolutePath = file.path;
    // final manifestJson = await DefaultAssetBundle.of(context).loadString(widget.meme.url);
    var imageFile =
        await DefaultCacheManager().getImageFile(imageUrl);
    
   var croppedFile = (await ImageCropper().cropImage(
      sourcePath: imageFile.toString(),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    )) ;
    

  }

 


}
