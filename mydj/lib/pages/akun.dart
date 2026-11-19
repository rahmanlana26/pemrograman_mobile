import 'package:flutter/material.dart';
import 'package:mydj/components/password_field.dart';
import 'package:mydj/pages/login_page.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({super.key, required this.title});

  final String title;

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  // Keluar dari aplikasi, kembali ke halaman login.
  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ganti Sandi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(thickness: 2),
            SizedBox(height: 10),
            Text('Sandi Saat Ini'),
            SizedBox(height: 10),
            // -----------------
            PasswordField(), // <-- Tambahkan di sini
            // -----------------
            SizedBox(height: 10),
            Text('Sandi Baru'),
            SizedBox(height: 10),
            PasswordField(),
            SizedBox(height: 10),
            Text('Konfirmasi Sandi Baru'),
            SizedBox(height: 10),
            PasswordField(),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // <-- Lebar button akan maksimal.
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Simpan'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Keluar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(thickness: 2),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => {_logout(context)},
                child: Text('Keluar dari Aplikasi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

