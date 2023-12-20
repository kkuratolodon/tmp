// To parse this JSON data, do
//
//     final peminjaman = peminjamanFromJson(jsonString);

import 'dart:convert';

List<Peminjaman> peminjamanFromJson(String str) => List<Peminjaman>.from(json.decode(str).map((x) => Peminjaman.fromJson(x)));

String peminjamanToJson(List<Peminjaman> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Peminjaman {
  String model;
  int pk;
  Fields fields;

  Peminjaman({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Peminjaman.fromJson(Map<String, dynamic> json) => Peminjaman(
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
  DateTime tglDipinjam;
  int durasiPeminjaman;
  DateTime tglBatas;
  dynamic tglDikembalikan;
  bool isReturned;

  Fields({
    required this.user,
    required this.book,
    required this.tglDipinjam,
    required this.durasiPeminjaman,
    required this.tglBatas,
    required this.tglDikembalikan,
    required this.isReturned,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    user: json["user"],
    book: json["book"],
    tglDipinjam: DateTime.parse(json["tgl_dipinjam"]),
    durasiPeminjaman: json["durasi_peminjaman"],
    tglBatas: DateTime.parse(json["tgl_batas"]),
    tglDikembalikan: json["tgl_dikembalikan"],
    isReturned: json["is_returned"],
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "book": book,
    "tgl_dipinjam": "${tglDipinjam.year.toString().padLeft(4, '0')}-${tglDipinjam.month.toString().padLeft(2, '0')}-${tglDipinjam.day.toString().padLeft(2, '0')}",
    "durasi_peminjaman": durasiPeminjaman,
    "tgl_batas": "${tglBatas.year.toString().padLeft(4, '0')}-${tglBatas.month.toString().padLeft(2, '0')}-${tglBatas.day.toString().padLeft(2, '0')}",
    "tgl_dikembalikan": tglDikembalikan,
    "is_returned": isReturned,
  };
}
