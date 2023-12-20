// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

List<Book> bookFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  Model model;
  int pk;
  Fields fields;

  Book({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String name;
  String author;
  double rating;
  int review;
  int price;
  int year;
  String genre;
  String image;
  String description;
  bool isDipinjam;
  int cntDipinjam;

  Fields({
    required this.name,
    required this.author,
    required this.rating,
    required this.review,
    required this.price,
    required this.year,
    required this.genre,
    required this.image,
    required this.description,
    required this.isDipinjam,
    required this.cntDipinjam,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        author: json["author"],
        rating: json["rating"]?.toDouble(),
        review: json["review"],
        price: json["price"],
        year: json["year"],
        genre: json["genre"],
        image: json["image"],
        description: json["description"],
        isDipinjam: json["is_dipinjam"],
        cntDipinjam: json["cnt_dipinjam"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "author": author,
        "rating": rating,
        "review": review,
        "price": price,
        "year": year,
        "genre": genre,
        "image": image,
        "description": description,
        "is_dipinjam": isDipinjam,
        "cnt_dipinjam": cntDipinjam,
      };
}

enum Model { KATALOG_BOOK }

final modelValues = EnumValues({"katalog.book": Model.KATALOG_BOOK});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
