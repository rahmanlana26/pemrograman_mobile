import 'package:flutter/material.dart';
import 'package:mydj/data/data_provider.dart';
import 'package:mydj/data/jurnal.dart';
import 'package:mydj/pages/buat_jurnal_page.dart';
import 'package:provider/provider.dart';

// Halaman detail jurnal: menampilkan seluruh atribut jurnal sebagai label/teks
// (read-only) beserta tombol untuk membuka halaman edit.
class DetailJurnalPage extends StatelessWidget {
  const DetailJurnalPage({
    super.key,
    required this.jurnal,
    this.title = 'Detail Jurnal',
  });

  final Jurnal jurnal;
  final String title;

  // Mengambil data terbaru dari Provider berdasarkan id. Dengan begitu, setelah
  // jurnal diedit, halaman ini langsung menampilkan data yang baru.
  Jurnal _jurnalTerbaru(BuildContext context) {
    final List<Jurnal> daftarJurnal = context
        .watch<DataProvider>()
        .jurnalTersimpan;
    for (final Jurnal item in daftarJurnal) {
      if (item.id == jurnal.id) {
        return item;
      }
    }
    // Jika data belum termuat, pakai objek yang dikirim dari halaman daftar.
    return jurnal;
  }

  // Membuka halaman edit dengan membawa data jurnal yang sedang dilihat.
  void _bukaEdit(BuildContext context, Jurnal jurnal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BuatJurnalPage(title: 'Edit Jurnal', jurnal: jurnal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Jurnal data = _jurnalTerbaru(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _barisInfo(context, 'Kelas', data.kelas),
              _barisInfo(context, 'Mata Pelajaran', data.mapel),
              _barisInfo(context, 'Jam Ke-', data.jam.toString()),
              _barisInfo(
                context,
                'Tujuan Pembelajaran',
                data.tujuanPembelajaran,
              ),
              _barisInfo(
                context,
                'Materi / Topik Pembelajaran',
                data.materiTopikPembelajaran,
              ),
              _barisInfo(
                context,
                'Kegiatan Pembelajaran',
                data.kegiatanPembelajaran,
              ),
              _barisInfo(
                context,
                'Dimensi Profil Pelajar Pancasila',
                data.dimensiProfilPelajarPancasila,
              ),
              _barisInfo(context, 'Waktu Dibuat', _formatWaktu(data.createdAt)),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () => _bukaEdit(context, data),
                  child: const Text('Edit Jurnal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Satu baris detail: judul atribut di atas, nilainya di bawah (read-only).
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

  // Format tanggal & jam tanpa paket tambahan, mis. 20/11/2026 14:05.
  String _formatWaktu(DateTime waktu) {
    String duaDigit(int nilai) => nilai.toString().padLeft(2, '0');

    return '${duaDigit(waktu.day)}/${duaDigit(waktu.month)}/${waktu.year} '
        '${duaDigit(waktu.hour)}:${duaDigit(waktu.minute)}';
  }
}
