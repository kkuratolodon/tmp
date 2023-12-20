// To parse this JSON data, do
//
//     final laporan = laporanFromJson(jsonString);

import 'dart:convert';

List<Laporan> laporanFromJson(String str) =>
    List<Laporan>.from(json.decode(str).map((x) => Laporan.fromJson(x)));

String laporanToJson(List<Laporan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Laporan {
  String model;
  int pk;
  Fields fields;

  Laporan({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Laporan.fromJson(Map<String, dynamic> json) => Laporan(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int user;
  int book;
  String name;
  String description;

  Fields({
    required this.user,
    required this.book,
    required this.name,
    required this.description,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        book: json["book"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "book": book,
        "name": name,
        "description": description,
      };
}
