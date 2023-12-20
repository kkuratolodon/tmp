// ignore_for_file: unused_import, unused_local_variable, library_private_types_in_public_api, prefer_final_fields, curly_braces_in_flow_control_structures, prefer_const_constructors, unused_element, sort_child_properties_last, prefer_is_empty

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pageturn_mobile/apps/Homepage/menu.dart';
import 'package:pageturn_mobile/apps/Peminjaman/models/peminjaman.dart';
import 'package:pageturn_mobile/apps/Peminjaman/screens/peminjaman_page.dart';
import 'package:pageturn_mobile/apps/Peminjaman/screens/pengembalian_page.dart';
import 'package:pageturn_mobile/apps/laporan_buku_rusak/models/laporan.dart';
import 'package:pageturn_mobile/book.dart';
import 'package:pageturn_mobile/components/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ListLaporan extends StatefulWidget {
  const ListLaporan({Key? key}) : super(key: key);

  @override
  _ListLaporanState createState() => _ListLaporanState();
}

class _ListLaporanState extends State<ListLaporan> {
  List<Laporan> _dipinjam = [];
  List<int> _telat = [];
  int _selectedIndex = 2;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List<Book> _booksList = [];
  List<Book> _allBooks = [];
  List<Laporan> _peminjamanList = [];
  List<int> _selectedBooks = [];
  String _query = "";
  List<String> _selectedGenres = [];
  List<MultiSelectItem<String>> _genresItems = [];

  Future<void> _loadGenres() async {
    var url = Uri.parse('http://10.0.2.2:8000/katalog/get-genres/');
    var response = await http.get(url);
    var jsonResponse = json.decode(response.body) as Map<String, dynamic>;
    List<String> genres = List<String>.from(jsonResponse['genres']);
    setState(() {
      _genresItems =
          genres.map((genre) => MultiSelectItem<String>(genre, genre)).toList();
    });
  }

  Future<List<Book>> fetchBooks(CookieRequest request) async {
    final response1 =
        await request.get('http://10.0.2.2:8000/katalog/get-book/');
    List<Book> allBooks = [];
    for (var d in response1) {
      if (d != null) {
        allBooks.add(Book.fromJson(d));
      }
    }
    _allBooks = allBooks;
    return allBooks;
  }

  Future<List<Book>> fetchPeminjaman(CookieRequest request) async {
    var queryParameters = {
      'search': _query,
      'genres': _selectedGenres,
    };
    var uri = Uri.http(
        '10.0.2.2:8000', '/laporan_buku_rusak/get-laporan/', queryParameters);

    final response = await request.get(uri.toString());
    List<Book> listBooks = [];
    List<Laporan> listPeminjaman = [];
    for (var d in response) {
      if (d != null) {
        Laporan item = Laporan.fromJson(d);
        Book? book =
            _allBooks.firstWhere((book) => book.pk == item.fields.book);
        if (!listBooks.contains(book)) listBooks.add(book);
        listPeminjaman.add(item);
      }
    }
    listBooks.sort((a, b) {
      return a.fields.name.compareTo(b.fields.name);
    });
    setState(() {
      _booksList = listBooks;
      _peminjamanList = listPeminjaman;
    });
    return listBooks;
  }

  void _showMultiSelect(BuildContext context) async {
    final items = _genresItems;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor:
                Colors.white, // Ensuring dialog background is white
            colorScheme: ColorScheme.dark(
              // Pastikan skema warna gelap
              primary: Colors.white, // Warna utama dalam dialog
              onPrimary:
                  Colors.white, // Warna untuk teks dan ikon pada primaryColor
              surface: Colors.black87, // Warna permukaan komponen
              onSurface: Colors.white, // Warna teks dan ikon pada surface
              // secondary: Colors.white, // Warna aksen atau sekunder
            ),
          ),
          child: MultiSelectDialog(
            backgroundColor:
                Colors.white, // Set your desired background color here
            items: items,
            initialValue: _selectedGenres,
            onConfirm: (values) {
              setState(() {
                _selectedGenres = List<String>.from(values);
                fetchPeminjaman(context.read<CookieRequest>());
              });
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff282626),
              surfaceTintColor: Colors.transparent,
              title: const Text(
                'Instruksi',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text(
                      'Klik buku untuk melihat detail peminjaman.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    });
  }

  Future<void> _initializeData() async {
    CookieRequest request = context.read<CookieRequest>();
    await fetchBooks(request);
    _loadGenres();
    fetchPeminjaman(request);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History Peminjaman Buku',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0, // Larger  font size for the title
          ),
        ),
        backgroundColor: const Color(0xFF282626),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Books list
          Expanded(
            child: _booksList.isEmpty
                ? _selectedGenres.length > 0 &&
                        _selectedGenres.length < _genresItems.length
                    ? Center(
                        child: Text(
                          "Kamu belum pernah\nmeminjam buku apapun\ndengan genre tersebut.",
                          textAlign: TextAlign.center, // Align text to center
                          style: TextStyle(
                            fontSize: 28, // Adjust the font size as needed
                            fontWeight: FontWeight.bold, // Bold text
                            color: Colors.grey, // Optional: for grey text color
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          "Kamu belum pernah\nmeminjam buku apapun.",
                          textAlign: TextAlign.center, // Align text to center
                          style: TextStyle(
                            fontSize: 28, // Adjust the font size as needed
                            fontWeight: FontWeight.bold, // Bold text
                            color: Colors.grey, // Optional: for grey text color
                          ),
                        ),
                      )
                : ListView.builder(
                    itemCount: _booksList.length,
                    itemBuilder: (context, index) {
                      Book book = _booksList[index];
                      bool isSelected = _selectedBooks.contains(book.pk);
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedBooks.clear();
                            _selectedBooks.add(book.pk);
                            _dipinjam = _peminjamanList
                                .where((item) => item.fields.book == book.pk)
                                .toList();
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Color(0xff282626),
                                surfaceTintColor: Colors.transparent,
                                title: Text(
                                  book.fields.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18, // Adjust the font size
                                    fontWeight:
                                        FontWeight.bold, // Make the title bold
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      for (int i = 0; i < _dipinjam.length; i++)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Judul Laporan: ${_dipinjam[i].fields.name}.',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Deskripsi Laporan: ${_dipinjam[i].fields.description}.',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          color: isSelected ? Color(0xFF87CEFA) : Colors.white,
                          child: ListTile(
                            title: Text(
                              book.fields.name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              book.fields.author,
                              style: TextStyle(fontSize: 14),
                            ),
                            leading: Image.network(
                              book.fields.image,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 200,
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                // Handle rendering errors
                                return Image.network(
                                  'https://cdn.discordapp.com/attachments/1049115719306051644/1186325973268975716/nope-not-here.png?ex=6592d728&is=65806228&hm=ed928cadb7e25d1ac275f43953b9498ca39557ddfffaa82b07443810b4c3caac&',
                                  fit: BoxFit.cover,
                                  height: 150,
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
