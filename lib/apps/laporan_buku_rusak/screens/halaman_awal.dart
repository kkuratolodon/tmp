import 'package:flutter/material.dart';
import 'package:pageturn_mobile/apps/laporan_buku_rusak/screens/add_laporan.dart';
import 'package:pageturn_mobile/apps/laporan_buku_rusak/screens/daftar_laporan.dart';
import 'package:pageturn_mobile/components/left_drawer.dart';
// import 'package:pageturn_mobile/apps/laporan_buku_rusak/pages/add_laporan.dart';
// import 'package:pageturn_mobile/apps/laporan_buku_rusak/widgets/left_drawer.dart';

class HalamanLaporan extends StatelessWidget {
  HalamanLaporan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LeftDrawer(),
      appBar: AppBar(
        title: const Text(
          'PAGETURN',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF282626),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                'Laporan Buku Rusak',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Tombol Add Laporan
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LaporanForm()),
                );
              },
              child: Text('Add Laporan'),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListLaporan()),
                );
              },
              child: Text('List Laporan'),
            ),
          ),
        ],
      ),
    );
  }
}