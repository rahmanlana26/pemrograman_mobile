// Widget test untuk halaman "Tentang Aplikasi" MyDJ.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mydj/data/data_provider.dart';
import 'package:mydj/data/jurnal.dart';
import 'package:mydj/pages/buat_jurnal_page.dart';
import 'package:mydj/pages/detail_jurnal_page.dart';
import 'package:mydj/pages/lihat_jurnal_page.dart';
import 'package:mydj/pages/simple_home_page.dart';
import 'package:mydj/pages/tentang_aplikasi.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Tentang Aplikasi memuat nama, tagline, versi, dan pembuat', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TentangAplikasiPage()));
    await tester.pumpAndSettle();

    // Nama aplikasi.
    expect(find.text('MyDJ'), findsOneWidget);
    // Tagline.
    expect(find.textContaining('Aplikasi Jurnal Harian Guru'), findsOneWidget);
    // Versi.
    expect(find.textContaining('Version: 1.0.0'), findsOneWidget);
    // Pembuat.
    expect(find.textContaining('Nor Rahman Maulana'), findsOneWidget);
  });

  testWidgets('Tentang Aplikasi menampilkan URL pembuat yang dapat di-tap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TentangAplikasiPage()));
    await tester.pumpAndSettle();

    // URL harus tampil sebagai teks yang diawali http(s)://.
    final Finder urlFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is Text &&
          widget.data != null &&
          widget.data!.startsWith('https://'),
    );
    expect(urlFinder, findsOneWidget);

    // Teks URL harus berada di dalam area yang menerima tap (InkWell).
    expect(
      find.ancestor(of: urlFinder, matching: find.byType(InkWell)),
      findsWidgets,
    );

    // Pastikan URL sudah terlihat pada ukuran layar default tes (800x600) agar
    // benar-benar bisa di-tap tanpa perlu scroll.
    final Size ukuranLayar =
        tester.view.physicalSize / tester.view.devicePixelRatio;
    expect(tester.getCenter(urlFinder).dy, lessThan(ukuranLayar.height));

    // Tap tidak boleh melempar exception walaupun plugin url_launcher tidak
    // tersedia di lingkungan test.
    await tester.ensureVisible(urlFinder);
    await tester.pumpAndSettle();
    await tester.tap(urlFinder);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tentang Aplikasi tidak overflow pada layar ponsel kecil', (
    WidgetTester tester,
  ) async {
    // Ukuran layar 360x640 (ponsel kecil) dengan devicePixelRatio 3.
    tester.view.physicalSize = const Size(360, 640) * 3;
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: TentangAplikasiPage()));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('MyDJ'), findsOneWidget);
  });

  testWidgets('Tombol Tentang Aplikasi di beranda membuka halaman yang benar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: SimpleHomePage(title: 'Beranda')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tentang Aplikasi'));
    await tester.pumpAndSettle();

    expect(find.byType(TentangAplikasiPage), findsOneWidget);
    expect(find.text('MyDJ'), findsOneWidget);
  });

  testWidgets(
    'Detail Jurnal menampilkan semua atribut sebagai teks read-only',
    (WidgetTester tester) async {
      final Jurnal jurnal = _contohJurnal();

      await tester.pumpWidget(
        ChangeNotifierProvider<DataProvider>.value(
          value: _FakeDataProvider([jurnal]),
          child: MaterialApp(home: DetailJurnalPage(jurnal: jurnal)),
        ),
      );
      await tester.pumpAndSettle();

      // Judul setiap atribut jurnal.
      expect(find.text('Kelas'), findsOneWidget);
      expect(find.text('Mata Pelajaran'), findsOneWidget);
      expect(find.text('Jam Ke-'), findsOneWidget);
      expect(find.text('Tujuan Pembelajaran'), findsOneWidget);
      expect(find.text('Materi / Topik Pembelajaran'), findsOneWidget);
      expect(find.text('Kegiatan Pembelajaran'), findsOneWidget);
      expect(find.text('Dimensi Profil Pelajar Pancasila'), findsOneWidget);
      expect(find.text('Waktu Dibuat'), findsOneWidget);

      // Nilai setiap atribut.
      expect(find.text('XII IPA 1'), findsOneWidget);
      expect(find.text('Matematika'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Tujuan A'), findsOneWidget);
      expect(find.text('Materi B'), findsOneWidget);
      expect(find.text('Kegiatan C'), findsOneWidget);
      expect(find.text('Dimensi D'), findsOneWidget);
      expect(find.text('20/11/2026 14:05'), findsOneWidget);

      // Read-only: tidak ada field isian di halaman detail.
      expect(find.byType(TextField), findsNothing);
    },
  );

  testWidgets('Tombol Edit Jurnal membuka halaman edit dengan data terisi', (
    WidgetTester tester,
  ) async {
    final Jurnal jurnal = _contohJurnal();

    await tester.pumpWidget(
      ChangeNotifierProvider<DataProvider>.value(
        value: _FakeDataProvider([jurnal]),
        child: MaterialApp(home: DetailJurnalPage(jurnal: jurnal)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Edit Jurnal'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit Jurnal'));
    await tester.pumpAndSettle();

    // Halaman edit memakai ulang BuatJurnalPage.
    expect(find.byType(BuatJurnalPage), findsOneWidget);

    // Semua field sudah terisi (pre-fill) dengan data jurnal yang ada.
    final List<TextField> fields = tester
        .widgetList<TextField>(find.byType(TextField))
        .toList();
    expect(fields[0].controller?.text, 'XII IPA 1'); // Kelas
    expect(fields[1].controller?.text, 'Matematika'); // Nama Mapel
    expect(fields[2].controller?.text, 'Tujuan A');
    expect(fields[3].controller?.text, 'Materi B');
    expect(fields[4].controller?.text, 'Kegiatan C');
    expect(fields[5].controller?.text, 'Dimensi D');

    // Pilihan jam juga ikut terisi.
    final DropdownButtonFormField<String> dropdown = tester
        .widget<DropdownButtonFormField<String>>(
          find.byType(DropdownButtonFormField<String>),
        );
    expect(dropdown.initialValue, '3');
  });

  testWidgets('Mengetuk satu baris di Lihat Jurnal membuka halaman detail', (
    WidgetTester tester,
  ) async {
    final Jurnal jurnal = _contohJurnal();

    await tester.pumpWidget(
      ChangeNotifierProvider<DataProvider>.value(
        value: _FakeDataProvider([jurnal]),
        child: const MaterialApp(home: LihatJurnalPage(title: 'Lihat Jurnal')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('XII IPA 1'));
    await tester.pumpAndSettle();

    expect(find.byType(DetailJurnalPage), findsOneWidget);
    expect(find.text('Mata Pelajaran'), findsOneWidget);
  });

  testWidgets('Simpan hasil edit memperbarui jurnal, bukan menambah baris', (
    WidgetTester tester,
  ) async {
    final Jurnal jurnal = _contohJurnal();
    final _FakeDataProvider provider = _FakeDataProvider([jurnal]);

    await tester.pumpWidget(
      ChangeNotifierProvider<DataProvider>.value(
        value: provider,
        child: MaterialApp(home: DetailJurnalPage(jurnal: jurnal)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Edit Jurnal'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit Jurnal'));
    await tester.pumpAndSettle();

    // Ubah kelas, lalu simpan perubahannya.
    await tester.enterText(find.byType(TextField).first, 'XI IPS 2');
    // Tunggu animasi auto-scroll akibat field yang mendapat fokus selesai dulu,
    // baru gulir ke tombol Simpan.
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Simpan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    // Kembali ke halaman detail dan langsung menampilkan data baru.
    expect(find.byType(DetailJurnalPage), findsOneWidget);
    expect(find.text('XI IPS 2'), findsOneWidget);

    // UPDATE dipakai, bukan INSERT.
    expect(provider.jumlahUbah, 1);
    expect(provider.jumlahTambah, 0);
    expect(provider.jurnalTersimpan.length, 1);

    // Biarkan SnackBar selesai agar tidak ada timer yang tertinggal.
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('Membuat jurnal baru tetap menambah data (mode buat)', (
    WidgetTester tester,
  ) async {
    final _FakeDataProvider provider = _FakeDataProvider([]);

    await tester.pumpWidget(
      ChangeNotifierProvider<DataProvider>.value(
        value: provider,
        child: const MaterialApp(home: BuatJurnalPage(title: 'Buat Jurnal')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'X IPA 1');
    // Tunggu animasi auto-scroll akibat field yang mendapat fokus selesai dulu,
    // baru gulir ke tombol Simpan.
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Simpan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(provider.jumlahTambah, 1);
    expect(provider.jumlahUbah, 0);
    expect(provider.jurnalTersimpan.single.kelas, 'X IPA 1');

    // Biarkan SnackBar selesai agar tidak ada timer yang tertinggal.
    await tester.pump(const Duration(seconds: 5));
  });
}

// Jurnal contoh yang dipakai oleh beberapa pengujian di atas.
Jurnal _contohJurnal() {
  return Jurnal(
    id: 1,
    kelas: 'XII IPA 1',
    mapel: 'Matematika',
    jam: 3,
    tujuanPembelajaran: 'Tujuan A',
    materiTopikPembelajaran: 'Materi B',
    kegiatanPembelajaran: 'Kegiatan C',
    dimensiProfilPelajarPancasila: 'Dimensi D',
    createdAt: DateTime(2026, 11, 20, 14, 5),
  );
}

// DataProvider tiruan: tidak menyentuh SQLite, hanya menyimpan data di memori
// agar alur navigasi, pre-fill, dan penyimpanan perubahan bisa diuji.
class _FakeDataProvider extends DataProvider {
  _FakeDataProvider(List<Jurnal> daftarJurnal)
    : _daftarJurnal = [...daftarJurnal];

  final List<Jurnal> _daftarJurnal;

  // Pencatat berapa kali INSERT dan UPDATE dipanggil.
  int jumlahTambah = 0;
  int jumlahUbah = 0;

  @override
  List<Jurnal> get jurnalTersimpan => List.unmodifiable(_daftarJurnal);

  @override
  Future<void> muatJurnal() async {}

  @override
  Future<void> tambahJurnal(Jurnal jurnal) async {
    jumlahTambah++;
    _daftarJurnal.add(jurnal);
    notifyListeners();
  }

  @override
  Future<void> ubahJurnal(Jurnal jurnal) async {
    jumlahUbah++;
    final int index = _daftarJurnal.indexWhere((item) => item.id == jurnal.id);
    if (index == -1) {
      _daftarJurnal.add(jurnal);
    } else {
      _daftarJurnal[index] = jurnal;
    }
    notifyListeners();
  }

  @override
  Future<void> hapusJurnal(int id) async {
    _daftarJurnal.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
