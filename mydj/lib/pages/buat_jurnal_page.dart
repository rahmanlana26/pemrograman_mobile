import 'package:flutter/material.dart';
import 'package:mydj/components/media_selector.dart';
import 'package:mydj/data/data_provider.dart';
import 'package:mydj/data/jurnal.dart';
import 'package:provider/provider.dart';

class BuatJurnalPage extends StatefulWidget {
  // `jurnal` bersifat opsional:
  // - null   -> halaman ini dipakai untuk membuat jurnal baru.
  // - terisi -> halaman ini dipakai untuk mengedit jurnal yang sudah ada,
  //             sehingga semua field langsung terisi data jurnal tersebut.
  const BuatJurnalPage({super.key, required this.title, this.jurnal});

  final String title;
  final Jurnal? jurnal;

  @override
  State<BuatJurnalPage> createState() {
    return _BuatJurnalPageState();
  }
}

class _BuatJurnalPageState extends State<BuatJurnalPage> {
  String kelas = '';
  String mapel = '';
  int jamKe = 0;
  String tujuanPembelajaran = '';
  String materiTopikPembelajaran = '';
  String kegiatanPembelajaran = '';
  String dimensiProfilPelajarPancasila = '';

  // Controller dipakai agar field bisa langsung terisi (pre-fill) ketika
  // halaman ini dibuka untuk mengedit jurnal yang sudah ada.
  late final TextEditingController _kelasController;
  late final TextEditingController _mapelController;
  late final TextEditingController _tujuanPembelajaranController;
  late final TextEditingController _materiTopikPembelajaranController;
  late final TextEditingController _kegiatanPembelajaranController;
  late final TextEditingController _dimensiProfilPelajarPancasilaController;

  // true jika halaman ini dipakai untuk mengedit jurnal yang sudah tersimpan.
  bool get _modeEdit => widget.jurnal != null;

  @override
  void initState() {
    super.initState();

    // Ambil jurnal yang akan diedit (null jika sedang membuat jurnal baru).
    final Jurnal? jurnal = widget.jurnal;

    // Isi seluruh state dengan data jurnal yang sudah ada.
    kelas = jurnal?.kelas ?? '';
    mapel = jurnal?.mapel ?? '';
    jamKe = jurnal?.jam ?? 0;
    tujuanPembelajaran = jurnal?.tujuanPembelajaran ?? '';
    materiTopikPembelajaran = jurnal?.materiTopikPembelajaran ?? '';
    kegiatanPembelajaran = jurnal?.kegiatanPembelajaran ?? '';
    dimensiProfilPelajarPancasila =
        jurnal?.dimensiProfilPelajarPancasila ?? '';

    // Isi field dengan nilai yang sama supaya tampil pre-fill.
    _kelasController = TextEditingController(text: kelas);
    _mapelController = TextEditingController(text: mapel);
    _tujuanPembelajaranController = TextEditingController(
      text: tujuanPembelajaran,
    );
    _materiTopikPembelajaranController = TextEditingController(
      text: materiTopikPembelajaran,
    );
    _kegiatanPembelajaranController = TextEditingController(
      text: kegiatanPembelajaran,
    );
    _dimensiProfilPelajarPancasilaController = TextEditingController(
      text: dimensiProfilPelajarPancasila,
    );
  }

  @override
  void dispose() {
    _kelasController.dispose();
    _mapelController.dispose();
    _tujuanPembelajaranController.dispose();
    _materiTopikPembelajaranController.dispose();
    _kegiatanPembelajaranController.dispose();
    _dimensiProfilPelajarPancasilaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kelas:'),
              SizedBox(height: 10),
              TextField(
                controller: _kelasController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Masukkan Kelas',
                ),
                onChanged: (value) => {
                  setState(() {
                    kelas = value;
                  }),
                },
              ),
              SizedBox(height: 10),
              Text('Nama Mapel'),
              SizedBox(height: 10),
              TextField(
                controller: _mapelController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Masukkan Nama Mapel',
                ),
                onChanged: (value) => {
                  setState(() {
                    mapel = value;
                  }),
                },
              ),
              SizedBox(height: 10),
              Text('Jam ke-'),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                // Pre-fill pilihan jam ketika sedang mengedit jurnal.
                initialValue: (jamKe >= 1 && jamKe <= 8)
                    ? jamKe.toString()
                    : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Pilih Jam',
                ),
                items: [
                  DropdownMenuItem(value: '1', child: Text('1')),
                  DropdownMenuItem(value: '2', child: Text('2')),
                  DropdownMenuItem(value: '3', child: Text('3')),
                  DropdownMenuItem(value: '4', child: Text('4')),
                  DropdownMenuItem(value: '5', child: Text('5')),
                  DropdownMenuItem(value: '6', child: Text('6')),
                  DropdownMenuItem(value: '7', child: Text('7')),
                  DropdownMenuItem(value: '8', child: Text('8')),
                ],
                onChanged: (value) => {
                  setState(() {
                    jamKe = int.tryParse(value ?? '') ?? 0;
                  }),
                },
              ),
              // Letakkan di bawah kode dropdown
              SizedBox(height: 10),
              _textArea(
                'Tujuan Pembelajaran',
                'Masukkan Tujuan Pembelajaran',
                _tujuanPembelajaranController,
                (text) => tujuanPembelajaran = text,
              ),
              SizedBox(height: 10),
              _textArea(
                'Materi/Topik Pembelajaran',
                'Masukkan Materi/Topik Pembelajaran',
                _materiTopikPembelajaranController,
                (text) => materiTopikPembelajaran = text,
              ),
              SizedBox(height: 10),
              _textArea(
                'Kegiatan Pembelajaran',
                'Masukkan Kegiatan Pembelajaran',
                _kegiatanPembelajaranController,
                (text) => kegiatanPembelajaran = text,
              ),
              SizedBox(height: 10),
              _textArea(
                'Dimensi Profil Pelajar Pancasila',
                'Tuliskan Dimensi Profil Pelajar Pancasila',
                _dimensiProfilPelajarPancasilaController,
                (text) => dimensiProfilPelajarPancasila = text,
              ),
              SizedBox(height: 16),
              Text('Foto Kegiatan'),
              SizedBox(height: 10),
              MediaSelector(), // <-- MediaSelector untuk foto.
              SizedBox(height: 16),
              Text('Video Kegiatan'),
              SizedBox(height: 10),
              MediaSelector(
                mediaType: MediaType.video,
              ), // <-- MediaSelector untuk video.
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity, // Lebar SizedBox akan maksimal.
                height: 50,
                child: ElevatedButton(
                  // ElevatedButton sebagai child dari SizedBox.
                  // Lebarnya akan mengikuti lebar parent-nya.
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () => {_saveJurnal(context)},
                  child: Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textArea(
    String label,
    String hint,
    TextEditingController controller, // <-- Controller agar bisa pre-fill
    void Function(String text) onChanged, // <-- Parameter ke-4 berupa fungsi
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: hint,
          ),
          maxLines: 4, // Property ini yang menjadikan seperti textarea
          onChanged: onChanged, // <-- Parameter ke-3 tersebut dimasukkan ke
          // property `onChanged` milik TextField
        ),
      ],
    );
  }

  Future<void> _saveJurnal(BuildContext context) async {
    // Saat mengedit, `id` dan `createdAt` diambil dari jurnal lama supaya data
    // yang tersimpan memperbarui baris yang sama (bukan membuat baris baru).
    Jurnal jurnal = Jurnal(
      id: widget.jurnal?.id,
      kelas: kelas,
      mapel: mapel,
      jam: jamKe,
      tujuanPembelajaran: tujuanPembelajaran,
      materiTopikPembelajaran: materiTopikPembelajaran,
      kegiatanPembelajaran: kegiatanPembelajaran,
      dimensiProfilPelajarPancasila: dimensiProfilPelajarPancasila,
      createdAt: widget.jurnal?.createdAt,
    );
    DataProvider provider = context.read<DataProvider>();
    final bool modeEdit = _modeEdit;

    if (modeEdit) {
      // UPDATE: perbarui jurnal yang sudah ada.
      await provider.ubahJurnal(jurnal);
    } else {
      // CREATE: simpan jurnal baru ke SQLite lewat Provider.
      await provider.tambahJurnal(jurnal);
    }

    // BuildContext dipakai setelah operasi async, jadi harus dicek dulu
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          modeEdit
              ? 'Perubahan jurnal berhasil disimpan'
              : 'Jurnal berhasil disimpan',
        ),
      ),
    );

    // Setelah menyimpan perubahan, kembali ke halaman detail jurnal.
    if (modeEdit) {
      Navigator.pop(context);
    }
  }
}
