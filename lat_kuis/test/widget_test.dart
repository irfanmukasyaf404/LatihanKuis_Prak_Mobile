import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lat_kuis/main.dart';
import 'package:lat_kuis/book.dart';
import 'package:lat_kuis/book_detail_page.dart';

void main() {
  testWidgets('Cek tampilan Halaman Login', (WidgetTester tester) async {
    // Jalankan aplikasi
    await tester.pumpWidget(const MyApp());

    // Memastikan judul AppBar 'Login' dan tombol Login muncul
    expect(find.text('Login'), findsNWidgets(2)); // Judul AppBar dan teks di Tombol
    expect(find.byType(TextField), findsNWidgets(2)); // Field Email dan Password
  });

  testWidgets('Login gagal menampilkan pesan error SnackBar', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Masukkan data salah
    await tester.enterText(find.byType(TextField).at(0), 'salah@mail.com');
    await tester.enterText(find.byType(TextField).at(1), 'passwordsalah');

    // Tekan tombol login (widget ke-2 bertuliskan 'Login')
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    // Verifikasi pesan error muncul
    expect(find.text('Email atau password tidak sesuai!'), findsOneWidget);
  });

  testWidgets('Login berhasil dan membuka Library Page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Masukkan dummy credentials
    await tester.enterText(find.byType(TextField).at(0), 'user@mail.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');

    // Tekan tombol login
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Pastikan masuk ke Library Page (AppBar 'Daftar Buku')
    expect(find.text('Daftar Buku'), findsOneWidget);

    // Pastikan buku dari book.dart muncul
    expect(find.text(bookList.first.title), findsOneWidget);
  });

  testWidgets('Detail buku menampilkan semua informasi sesuai ketentuan', (WidgetTester tester) async {
    final sampleBook = bookList.first;

    await tester.pumpWidget(
      MaterialApp(
        home: BookDetailPage(book: sampleBook),
      ),
    );

    // 1. AppBar judul buku
    expect(find.text(sampleBook.title), findsWidgets);

    // 2. Penulis
    expect(find.text(sampleBook.author), findsWidgets);

    // 3. Tahun terbit
    expect(find.text(sampleBook.year.toString()), findsWidgets);

    // 4. Deskripsi
    expect(find.text(sampleBook.description), findsOneWidget);

    // 5. Genre
    expect(find.text(sampleBook.genre), findsWidgets);

    // 6. Penerbit
    expect(find.text(sampleBook.publisher), findsOneWidget);

    // 7. Jumlah halaman
    expect(find.text('${sampleBook.pages} halaman'), findsOneWidget);

    // 8. Rating
    expect(find.text('${sampleBook.rating} / 5.0'), findsWidgets);
  });
}