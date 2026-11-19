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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                // minHeight membuat form berada di tengah layar saat ruang
                // masih cukup, tapi tetap bisa di-scroll saat keyboard muncul.
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 64,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/login_icon.png',
                            height: 130,
                            fit: BoxFit.contain,
                          ), // <-- Menampilkan gambar login
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Log-In',
                          textAlign: TextAlign.center,
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Masuk untuk mulai menulis jurnal harian Anda.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 32),
                        _fieldLabel(context, 'Nama Pengguna'),
                        const SizedBox(height: 8),
                        TextField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                          ),
                          onChanged: (value) {
                            setState(() {
                              namaPengguna = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _fieldLabel(context, 'Sandi'),
                        const SizedBox(height: 8),
                        PasswordField(
                          onChanged: (value) {
                            sandi = value;
                          },
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              textStyle: textTheme.titleMedium,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () => {login(context)},
                            child: const Text('Login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Label di atas setiap field, dibuat rata kiri agar sejajar dengan field-nya.
  Widget _fieldLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
