import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pageturn_mobile/apps/Authentication/login.dart';
import 'package:pageturn_mobile/apps/Peminjaman/screens/peminjaman_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const RegisterApp());
}

class RegisterApp extends StatelessWidget {
  const RegisterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
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
                      'Register',
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
                      controller: _password1Controller,
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: TextField(
                      obscureText: true,
                      controller: _password2Controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
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
                                String password1 = _password1Controller.text;
                                String password2 = _password2Controller.text;
                                if (username.isEmpty) {
                                  // Tampilkan pesan error untuk username
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Username tidak boleh kosong")),
                                  );
                                  return; // Hentikan fungsi jika username kosong
                                }

                                if (password1.isEmpty) {
                                  // Tampilkan pesan error untuk password
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Password tidak boleh kosong")),
                                  );
                                  return; // Hentikan fungsi jika password kosong
                                }
                                final response = await request.post(
                                    "http://10.0.2.2:8000/auth/register/", {
                                  'username': username,
                                  'password1': password1,
                                  'password2': password2,
                                });
                                bool status = response['status'];
                                if (status) {
                                  _usernameController.clear();
                                  _password1Controller.clear();
                                  _password2Controller.clear();
                                  String message = response['message'];
                                  String uname = response['username'];
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Register Berhasil'),
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
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginApp()),
                                  );

                                } else {
                                  _usernameController.clear();
                                  _password1Controller.clear();
                                  _password2Controller.clear();
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Register Gagal'),
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
                                  'Register →',
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
                                  text:
                                      "Already have an account? ", // Teks biasa
                                ),
                                TextSpan(
                                  text: 'Login',
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
                                                const LoginApp(),
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
