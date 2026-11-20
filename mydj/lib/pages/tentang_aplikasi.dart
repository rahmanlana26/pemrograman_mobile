import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Halaman statis berisi identitas aplikasi: nama, tagline, versi, pembuat,
// serta tautan ke halaman pembuat yang bisa di-tap untuk membuka browser.
class TentangAplikasiPage extends StatelessWidget {
  // Judul AppBar diberi nilai default supaya halaman ini tetap bisa dibuat
  // tanpa argumen (mis. dari widget test).
  const TentangAplikasiPage({super.key, this.title = 'Tentang Aplikasi'});

  final String title;

  // Identitas aplikasi dikumpulkan di satu tempat agar mudah diubah.
  static const String namaAplikasi = 'MyDJ';
  static const String tagline = 'Aplikasi Jurnal Harian Guru';
  static const String deskripsi =
      'Aplikasi pencatat jurnal harian untuk guru: tulis, simpan, dan lihat '
      'kembali jurnal mengajar Anda.';
  static const String versi = '1.0.0';
  static const String pembuat = 'Nor Rahman Maulana';
  static const String nimPembuat = '244107020056';
  static const String urlPembuat = 'https://github.com/nurrahmanmaulana';

  // Membuka tautan pembuat di browser. Dibungkus try-catch agar aplikasi tidak
  // berhenti ketika tidak ada browser (mis. saat dijalankan pada widget test).
  Future<void> _bukaUrlPembuat(BuildContext context) async {
    final Uri uri = Uri.parse(urlPembuat);
    bool berhasil = false;

    try {
      berhasil = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (error) {
      debugPrint('Gagal membuka $urlPembuat: $error');
    }

    // Setelah operasi async, pastikan widget-nya masih ada sebelum memakai
    // BuildContext.
    if (berhasil || !context.mounted) return;

    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(content: Text('Tidak dapat membuka browser.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/login_icon.png',
                  height: 88,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 12),
              // Nama aplikasi.
              Text(
                namaAplikasi,
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              // Tagline aplikasi.
              Text(
                tagline,
                textAlign: TextAlign.center,
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Divider(thickness: 1, color: colorScheme.outlineVariant),
              const SizedBox(height: 4),
              _barisInfo(context, 'Version', 'Version: $versi'),
              _barisInfo(context, 'Dibuat Oleh: ', '$pembuat ($nimPembuat)'),
              _barisTautanPembuat(context),
              const SizedBox(height: 8),
              Text(
                deskripsi,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Satu baris informasi: label kecil di atas, nilainya di bawah.
  Widget _barisInfo(BuildContext context, String label, String nilai) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(nilai, style: textTheme.bodyLarge),
        ],
      ),
    );
  }

  // URL pembuat ditampilkan sebagai teks sekaligus bisa di-tap. TextButton
  // sudah membungkus teksnya dengan InkWell sehingga menerima gesture tap.
  Widget _barisTautanPembuat(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'URL Pembuat',
            style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _bukaUrlPembuat(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: colorScheme.primary,
                textStyle: textTheme.bodyLarge,
              ),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: const Text(urlPembuat),
            ),
          ),
        ],
      ),
    );
  }
}
