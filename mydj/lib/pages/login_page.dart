import 'package:flutter/material.dart';
import 'package:mydj/components/password_field.dart';
import 'package:mydj/pages/simple_home_page.dart';

class LoginPage extends StatefulWidget {
  final String title = 'MyDJ - Welcome';

  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  String namaPengguna = ''; // <-- Nantinya digunakan untuk menyimpan username
  String sandi = ''; // <-- Yang ini digunakan untuk menyimpan password

  void login(BuildContext context) {
    if (namaPengguna == 'guru' && sandi == 'guru') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SimpleHomePage(title: 'Beranda'),
        ),
      );
    }
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
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/login_icon.png',
                  width: 250,
                ), // <-- Menampilkan gambar login
                Text(
                  'Log-In',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
                Text('Nama Pengguna:'),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  onChanged: (value) => {
                    setState(() {
                      namaPengguna = value;
                    }),
                  },
                ),
                SizedBox(height: 10),
                Text('Sandi:'),
                SizedBox(height: 10),
                PasswordField(
                  onChanged: (value) {
                    sandi = value;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => {login(context)},
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
