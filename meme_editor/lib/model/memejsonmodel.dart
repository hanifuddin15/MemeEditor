// To parse this JSON data, do
//
//     final memeJsonModel = memeJsonModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

MemeJsonModel memeJsonModelFromJson(String str) => MemeJsonModel.fromJson(json.decode(str));

String memeJsonModelToJson(MemeJsonModel data) => json.encode(data.toJson());

class MemeJsonModel {
    MemeJsonModel({
        required this.success,
        required this.data,
    });

    bool success;
    Data data;

    factory MemeJsonModel.fromJson(Map<String, dynamic> json) => MemeJsonModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        required this.memes,
    });

    List<Meme> memes;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        memes: List<Meme>.from(json["memes"].map((x) => Meme.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "memes": List<dynamic>.from(memes.map((x) => x.toJson())),
    };
}

class Meme {
    Meme({
        required this.id,
        required this.name,
        required this.url,
        required this.width,
        required this.height,
        required this.boxCount,
        required this.captions,
        required this.file
    });

    String id;
    String name;
    String url;
    int width;
    int height;
    int boxCount;
    int captions;
    File? file;

    factory Meme.fromJson(Map<String, dynamic> json) => Meme(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        width: json["width"],
        height: json["height"],
        boxCount: json["box_count"],
        captions: json["captions"], file: null,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "width": width,
        "height": height,
        "box_count": boxCount,
        "captions": captions,
    };
}
