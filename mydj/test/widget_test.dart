// Widget test untuk halaman "Tentang Aplikasi" MyDJ.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mydj/pages/simple_home_page.dart';
import 'package:mydj/pages/tentang_aplikasi.dart';

void main() {
  testWidgets('Tentang Aplikasi memuat nama, tagline, versi, dan pembuat', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TentangAplikasiPage()));
    await tester.pumpAndSettle();

    // Nama aplikasi.
    expect(find.text('MyDJ'), findsOneWidget);
    // Tagline.
    expect(find.textContaining('My Daily Journal'), findsOneWidget);
    // Versi.
    expect(find.textContaining('Versi 1.0.0'), findsOneWidget);
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
}
