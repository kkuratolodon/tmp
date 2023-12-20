// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pageturn_mobile/apps/Homepage/menu.dart';
import 'package:pageturn_mobile/apps/Katalog/screens/book_form.dart';
import 'package:pageturn_mobile/book.dart';
import 'package:pageturn_mobile/components/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class KatalogPage extends StatefulWidget {
  const KatalogPage({Key? key}) : super(key: key);

  @override
  _KatalogPageState createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {
  final _formKey = GlobalKey<FormState>();
  String? _role;
  int _selectedIndex = 0;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List<Book> _booksList = [];
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
  Future<void> fetchUser(CookieRequest request) async {
    final response = await request.get('http://10.0.2.2:8000/auth/get-user/');
    _role = response['role'];
  }
  Future<List<Book>> fetchBooks(CookieRequest request) async {
    var queryParameters = {
      'search': _query,
      'genres': _selectedGenres,
    };
    var uri = Uri.http(
        '10.0.2.2:8000', '/katalog/get-books-genre/', queryParameters);

    final response = await request.get(uri.toString());
    List<Book> listBooks = [];
    for (var d in response) {
      if (d != null) {
        listBooks.add(Book.fromJson(d));
      }
    }
    listBooks.sort((a, b) {
      if (a.fields.isDipinjam == b.fields.isDipinjam) {
        return a.fields.name.compareTo(b.fields
            .name); // Alphabetical sorting if `isDipinjam` status is same
      }
      return a.fields.isDipinjam
          ? 1
          : -1; // Books with `isDipinjam` as false come first
    });
    setState(() {
      _booksList = listBooks;
    });
    return listBooks;
  }

  void _showMultiSelect(BuildContext context) async {
    final items = _genresItems;
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          items: items,
          initialValue: _selectedGenres,
          onConfirm: (values) {
            setState(() {
              _selectedGenres = List<String>.from(values);
              fetchBooks(context.read<CookieRequest>());
            });
          },
        );
      },
    );
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadGenres();
    fetchUser(context.read<CookieRequest>());
    fetchBooks(context.read<CookieRequest>());
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  void _updateSearchResults(String query) {
    setState(() {
      _query = query;
    });
    fetchBooks(context.read<CookieRequest>());
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    Widget searchBar = _isSearching
        ? TextField(
      style: TextStyle(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search books...',
        hintStyle: TextStyle(color: Colors.white),
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search, color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear, color: Colors.white),
          onPressed: () {
            _searchController.clear();
            _updateSearchResults('');
            setState(() {
              _isSearching = false;
            });
          },
        ),
      ),
      onChanged: (value) {
        _updateSearchResults(value);
      },
    )
        : Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ElevatedButton(
          onPressed: () => _showMultiSelect(context),
          child: Row(
            children: <Widget>[
              Text(
                'Select Genres',
                style: TextStyle(fontSize: 16.0),
              ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            side: BorderSide(color: Colors.grey),
            padding: EdgeInsets.symmetric(horizontal: 55.0),
          ),
        ),
        ElevatedButton(
            onPressed: _startSearch,
            child: Row(
              children: <Widget>[
                Text(
                  'Search ',
                  style: TextStyle(
                      fontSize: 16.0), // Larger font size for button text
                ),
                Icon(Icons.search),
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors
                  .white, // Match the background color to 'Select Genres' button
              onPrimary: Colors
                  .black, // Match the text color to 'Select Genres' button
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(30), // Rounded corners
              ),
              side: BorderSide(color: Colors.grey), // Add border
              padding: EdgeInsets.symmetric(
                  horizontal:
                  14.0), // Horizontal padding inside the button
            )),
      ],
    );
    return Scaffold(
      drawer: LeftDrawer(),
      appBar: AppBar(
        title: Text(
          'Katalog',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0, // Larger  font size for the title
          ),
        ),
        backgroundColor: const Color(0xFF282626),
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(58.0),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16.0, right: 16, bottom: 10.0),
            child: searchBar,
          ),
        ),
      ),
      body: Column(
        children: [
          // Books list
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjust the number of columns here
                childAspectRatio: 2, // Adjust the aspect ratio of each card
              ),
              itemCount: _booksList.length,
              itemBuilder: (context, index) {
                Book book = _booksList[index];
                bool isSelected = _selectedBooks.contains(book.pk);

                return InkWell(
                  onTap: () {
                    setState(() {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(book.fields.name),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                Image.network(
                                    book.fields.image,
                                    height: 150,
                                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                      // Handle rendering errors
                                      return Image.network(
                                        'https://cdn.discordapp.com/attachments/1049115719306051644/1186325973268975716/nope-not-here.png?ex=6592d728&is=65806228&hm=ed928cadb7e25d1ac275f43953b9498ca39557ddfffaa82b07443810b4c3caac&',
                                        fit: BoxFit.cover,
                                        height: 150,
                                      );
                                    },
                                ), // Set desired image height
                                Text(book.fields.description),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    });
                  },
                  child: Container(
                    color: book.fields.isDipinjam
                        ? Color(0xFFF08080)
                        : isSelected
                        ? Color(0xFF87CEFA)
                        : Colors.white,
                    child: ListTile(
                      title: Text(book.fields.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      subtitle: Text(book.fields.author,
                          style: TextStyle(fontSize: 14)),
                      leading: Image.network(
                        book.fields.image,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 200,
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          // Handle rendering errors
                          return Image.network(
                            'https://cdn.discordapp.com/attachments/1049115719306051644/1186325973268975716/nope-not-here.png?ex=6592d728&is=65806228&hm=ed928cadb7e25d1ac275f43953b9498ca39557ddfffaa82b07443810b4c3caac&',
                            fit: BoxFit.cover,
                            width: 50,
                            height: 200,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if(_role == 'admin')
          SizedBox(height: 50),
        ],
      ),
      floatingActionButton: _role == 'admin' ? FloatingActionButton(
        onPressed: () {
          // Add your desired action when the button is pressed
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BookFormPage()));
        },
        child: Icon(Icons.add),
      )
      : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}