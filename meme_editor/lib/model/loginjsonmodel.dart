// To parse this JSON data, do
//
//     final loginJsonModel = loginJsonModelFromJson(jsonString);

import 'dart:convert';

LoginJsonModel loginJsonModelFromJson(String str) => LoginJsonModel.fromJson(json.decode(str));

String loginJsonModelToJson(LoginJsonModel data) => json.encode(data.toJson());

class LoginJsonModel {
    LoginJsonModel({
        required this.info,
        required this.item,
    });

    Info info;
    List<Item> item;

    factory LoginJsonModel.fromJson(Map<String, dynamic> json) => LoginJsonModel(
        info: Info.fromJson(json["info"]),
        item: List<Item>.from(json["item"].map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "info": info.toJson(),
        "item": List<dynamic>.from(item.map((x) => x.toJson())),
    };
}

class Info {
    Info({
        required this.postmanId,
        required this.name,
        required this.schema,
        required this.exporterId,
    });

    String postmanId;
    String name;
    String schema;
    String exporterId;

    factory Info.fromJson(Map<String, dynamic> json) => Info(
        postmanId: json["_postman_id"],
        name: json["name"],
        schema: json["schema"],
        exporterId: json["_exporter_id"],
    );

    Map<String, dynamic> toJson() => {
        "_postman_id": postmanId,
        "name": name,
        "schema": schema,
        "_exporter_id": exporterId,
    };
}

class Item {
    Item({
        required this.name,
        required this.event,
        required this.request,
        required this.response,
    });

    String name;
    List<Event> event;
    Request request;
    List<Response> response;

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json["name"],
        event: List<Event>.from(json["event"].map((x) => Event.fromJson(x))),
        request: Request.fromJson(json["request"]),
        response: List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "event": List<dynamic>.from(event.map((x) => x.toJson())),
        "request": request.toJson(),
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
    };
}

class Event {
    Event({
        required this.listen,
        required this.script,
    });

    String listen;
    Script script;

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        listen: json["listen"],
        script: Script.fromJson(json["script"]),
    );

    Map<String, dynamic> toJson() => {
        "listen": listen,
        "script": script.toJson(),
    };
}

class Script {
    Script({
        required this.exec,
        required this.type,
    });

    List<String> exec;
    String type;

    factory Script.fromJson(Map<String, dynamic> json) => Script(
        exec: List<String>.from(json["exec"].map((x) => x)),
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "exec": List<dynamic>.from(exec.map((x) => x)),
        "type": type,
    };
}

class Request {
    Request({
        required this.method,
        required this.header,
        required this.body,
        required this.url,
    });

    String method;
    List<RequestHeader> header;
    Body body;
    Url url;

    factory Request.fromJson(Map<String, dynamic> json) => Request(
        method: json["method"],
        header: List<RequestHeader>.from(json["header"].map((x) => RequestHeader.fromJson(x))),
        body: Body.fromJson(json["body"]),
        url: Url.fromJson(json["url"]),
    );

    Map<String, dynamic> toJson() => {
        "method": method,
        "header": List<dynamic>.from(header.map((x) => x.toJson())),
        "body": body.toJson(),
        "url": url.toJson(),
    };
}

class Body {
    Body({
        required this.mode,
        required this.urlencoded,
    });

    String mode;
    List<Urlencoded> urlencoded;

    factory Body.fromJson(Map<String, dynamic> json) => Body(
        mode: json["mode"],
        urlencoded: List<Urlencoded>.from(json["urlencoded"].map((x) => Urlencoded.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "mode": mode,
        "urlencoded": List<dynamic>.from(urlencoded.map((x) => x.toJson())),
    };
}

class Urlencoded {
    Urlencoded({
        required this.key,
        required this.value,
        required this.type,
        this.disabled,
    });

    String key;
    String value;
    Type type;
    bool? disabled;

    factory Urlencoded.fromJson(Map<String, dynamic> json) => Urlencoded(
        key: json["key"],
        value: json["value"],
        type: typeValues.map[json["type"]]!,
        disabled: json["disabled"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "type": typeValues.reverse[type],
        "disabled": disabled,
    };
}

enum Type { TEXT }

final typeValues = EnumValues({
    "text": Type.TEXT
});

class RequestHeader {
    RequestHeader({
        required this.key,
        required this.value,
    });

    String key;
    String value;

    factory RequestHeader.fromJson(Map<String, dynamic> json) => RequestHeader(
        key: json["key"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
    };
}

class Url {
    Url({
        required this.raw,
        this.protocol,
        required this.host,
        required this.path,
    });

    String raw;
    String? protocol;
    List<String> host;
    List<String> path;

    factory Url.fromJson(Map<String, dynamic> json) => Url(
        raw: json["raw"],
        protocol: json["protocol"],
        host: List<String>.from(json["host"].map((x) => x)),
        path: List<String>.from(json["path"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "raw": raw,
        "protocol": protocol,
        "host": List<dynamic>.from(host.map((x) => x)),
        "path": List<dynamic>.from(path.map((x) => x)),
    };
}

class Response {
    Response({
        required this.name,
        required this.originalRequest,
        required this.status,
        required this.code,
        required this.postmanPreviewlanguage,
        required this.header,
        required this.cookie,
        required this.body,
    });

    String name;
    Request originalRequest;
    String status;
    int code;
    String postmanPreviewlanguage;
    List<ResponseHeader> header;
    List<dynamic> cookie;
    String body;

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        name: json["name"],
        originalRequest: Request.fromJson(json["originalRequest"]),
        status: json["status"],
        code: json["code"],
        postmanPreviewlanguage: json["_postman_previewlanguage"],
        header: List<ResponseHeader>.from(json["header"].map((x) => ResponseHeader.fromJson(x))),
        cookie: List<dynamic>.from(json["cookie"].map((x) => x)),
        body: json["body"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "originalRequest": originalRequest.toJson(),
        "status": status,
        "code": code,
        "_postman_previewlanguage": postmanPreviewlanguage,
        "header": List<dynamic>.from(header.map((x) => x.toJson())),
        "cookie": List<dynamic>.from(cookie.map((x) => x)),
        "body": body,
    };
}

class ResponseHeader {
    ResponseHeader({
        required this.key,
        required this.value,
        this.name,
        this.description,
    });

    String key;
    String value;
    String? name;
    String? description;

    factory ResponseHeader.fromJson(Map<String, dynamic> json) => ResponseHeader(
        key: json["key"],
        value: json["value"],
        name: json["name"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "name": name,
        "description": description,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
