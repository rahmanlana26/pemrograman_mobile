import 'package:flutter/material.dart';

class SimpleHomePage extends StatefulWidget {
  const SimpleHomePage({super.key, required this.title});

  final String title;

  @override
  State<SimpleHomePage> createState() => _SimpleHomePageState();
}

class _SimpleHomePageState extends State<SimpleHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Lihat Jurnal'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Lihat Jurnal'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Lihat Jurnal'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Lihat Jurnal'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
