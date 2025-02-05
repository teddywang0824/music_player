import 'package:flutter/material.dart';
import 'view/audiodownload.dart';
import 'view/musiclist.dart';
import 'view/player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Music List",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(context: context, builder: (context) {
                  return const Dialog(
                    child: AudioDownload(),
                  );
                });
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      // body: const MusicList(),
      body: const MusicList(),
    );
  }
}
