import 'package:flutter/material.dart';
import 'package:mydj/components/media_selector.dart';
import 'package:mydj/data/data_provider.dart';
import 'package:mydj/data/jurnal.dart';
import 'package:provider/provider.dart';

class BuatJurnalPage extends StatefulWidget {
  const BuatJurnalPage({super.key, required this.title});

  final String title;

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
                (text) => tujuanPembelajaran = text,
              ),
              SizedBox(height: 10),
              _textArea(
                'Materi/Topik Pembelajaran',
                'Masukkan Materi/Topik Pembelajaran',
                (text) => materiTopikPembelajaran = text,
              ),
              SizedBox(height: 10),
              _textArea(
                'Kegiatan Pembelajaran',
                'Masukkan Kegiatan Pembelajaran',
                (text) => kegiatanPembelajaran = text,
              ),
              SizedBox(height: 10),
              _textArea(
                'Dimensi Profil Pelajar Pancasila',
                'Tuliskan Dimensi Profil Pelajar Pancasila',
                (text) => dimensiProfilPelajarPancasila = text,
              ),
              SizedBox(height: 10),
              Text('Foto Kegiatan'),
              SizedBox(height: 10),
              MediaSelector(), // <-- MediaSelector untuk foto.
              SizedBox(height: 10),
              Text('Video Kegiatan'),
              SizedBox(height: 10),
              MediaSelector(
                mediaType: MediaType.video,
              ), // <-- MediaSelector untuk video.
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity, // Lebar SizedBox akan maksimal.
                child: ElevatedButton(
                  // ElevatedButton sebagai child dari SizedBox.
                  // Lebarnya akan mengikuti lebar parent-nya.
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
    void Function(String text) onChanged, // <-- Parameter ke-3 berupa fungsi
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 10),
        TextField(
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

  void _saveJurnal(BuildContext context) {
    Jurnal jurnal = Jurnal(
      kelas: kelas,
      mapel: mapel,
      jam: jamKe,
      tujuanPembelajaran: tujuanPembelajaran,
      materiTopikPembelajaran: materiTopikPembelajaran,
      kegiatanPembelajaran: kegiatanPembelajaran,
      dimensiProfilPelajarPancasila: dimensiProfilPelajarPancasila,
    );
    DataProvider provider = context.read<DataProvider>();
    provider.addNew(jurnal);
  }
}
