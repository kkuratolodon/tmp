import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pageturn_mobile/apps/Authentication/register.dart';
import 'package:pageturn_mobile/apps/Homepage/menu.dart';
import 'package:pageturn_mobile/apps/Peminjaman/screens/peminjaman_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Gambar latar belakang
          Image.network(
            'https://cdn.discordapp.com/attachments/1049115719306051644/1186216037990019133/87fa6759b71b572610d86429ffd40cb3.png?ex=659270c6&is=657ffbc6&hm=57888655c4d0604932cb6bc1f74293a72181458e8b5092d362f7e12e80a123bb&',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          // Overlay gelap dengan opasitas
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Efek Blur (opsional, jika Anda ingin menambahkan)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
          // Konten formulir login
          Center(
            // Center digunakan untuk memusatkan Container
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.85, // Container mengambil 85% lebar layar
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // Mengambil ukuran minimum yang dibutuhkan oleh anak-anaknya
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Anak-anak Column rata kiri
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 35.0),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.orange, // Sesuaikan dengan warna tombol
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: TextField(
                      controller: _usernameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: TextField(
                      obscureText: true,
                      controller: _passwordController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  // _buildTextField(label: 'Password', isPassword: true),
                  SizedBox(height: 20),
                  Column(
                    mainAxisSize: MainAxisSize
                        .min, // Mengambil ukuran minimum yang dibutuhkan oleh anak-anaknya
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right:
                                36.0), // Padding di sisi kanan untuk menggeser tombol ke kiri
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .end, // Mendorong tombol ke kanan
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                String username = _usernameController.text;
                                String password = _passwordController.text;

                                final response = await request.login(
                                    "http://10.0.2.2:8000/auth/login/", {
                                  'username': username,
                                  'password': password,
                                });

                                if (request.loggedIn) {
                                  String message = response['message'];
                                  String uname = response['username'];
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage()),
                                  );
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                        content: Text(
                                            "$message Selamat datang, $uname.")));
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Login Gagal'),
                                      content: Text(response['message']),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 8.0), // Penyesuaian padding
                                child: Text(
                                  'Login →',
                                  style: TextStyle(
                                      fontSize:
                                          16), // Ukuran teks bisa disesuaikan
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary:
                                    Colors.orange, // Warna background button
                                onPrimary:
                                    Colors.white, // Warna foreground button
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 25.0), // Padding di sisi kanan dan atas
                        child: Align(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.white, // Gaya default untuk teks
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Don't have an account? ", // Teks biasa
                                ),
                                TextSpan(
                                  text: 'Register',
                                  style: TextStyle(
                                    color: Colors
                                        .orange, // Gaya untuk teks yang dapat diklik
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterApp(),
                                          ));
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
