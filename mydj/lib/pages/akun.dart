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
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: SafeArea(
        // SingleChildScrollView agar halaman tetap nyaman saat keyboard muncul.
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _sectionTitle(context, 'Ganti Sandi'),
              const SizedBox(height: 4),
              Divider(thickness: 1, color: colorScheme.outlineVariant),
              const SizedBox(height: 16),
              _fieldLabel(context, 'Sandi Saat Ini'),
              const SizedBox(height: 8),
              // -----------------
              PasswordField(), // <-- Tambahkan di sini
              // -----------------
              const SizedBox(height: 16),
              _fieldLabel(context, 'Sandi Baru'),
              const SizedBox(height: 8),
              PasswordField(),
              const SizedBox(height: 16),
              _fieldLabel(context, 'Konfirmasi Sandi Baru'),
              const SizedBox(height: 8),
              PasswordField(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, // <-- Lebar button akan maksimal.
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: const Text('Simpan'),
                ),
              ),
              const SizedBox(height: 32),
              _sectionTitle(context, 'Keluar'),
              const SizedBox(height: 4),
              Divider(thickness: 1, color: colorScheme.outlineVariant),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    side: BorderSide(color: colorScheme.error),
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () => {_logout(context)},
                  child: const Text('Keluar dari Aplikasi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Judul setiap bagian (Ganti Sandi, Keluar).
  Widget _sectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
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
