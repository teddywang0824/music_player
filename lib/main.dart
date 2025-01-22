import 'dart:io';
import 'package:flutter/material.dart';
// import 'view/musiclist.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:permission_handler/permission_handler.dart';

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        ],
      ),
      body: AudioDownload(),
    );
  }
}

class AudioDownload extends StatefulWidget {
  const AudioDownload({super.key});

  @override
  State<AudioDownload> createState() => _AudioDownloadState();
}

class _AudioDownloadState extends State<AudioDownload> {
  final TextEditingController _urlController = TextEditingController();
  String _status = ''; //指示
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _urlController,
          decoration: const InputDecoration(
            labelText: '輸入 Youtube 網址',
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: _isLoading
                ? null
                : () {
                    _download(_urlController.text);
                  },
            child: Text(_isLoading ? "處理中" : "下載")),
        const SizedBox(
          height: 20,
        ),
        Text(_status),
      ],
    );
  }

  // Future<void> _testPathProvider() async {
  //   var dir = await getApplicationDocumentsDirectory();
  //   debugPrint("---${dir.path}---");
  // }

  Future<void> _download(String url) async {
    setState(() {
      _isLoading = true;
      _status = '開始下載，請勿關閉...';
    });

    try {
      var state = await Permission.storage.request();
      if(!state.isGranted) {
        throw '需要儲存權限';
      }

      final yt = YoutubeExplode();

      final video = await yt.videos.get(url);
      final videoTitle = video.title;

      var manifest = await yt.videos.streams.getManifest(url);
      var audio = manifest.audioOnly.withHighestBitrate();

      var dir = await getExternalStorageDirectory();
      setState(() => _status = '下載中，請勿關閉...');
      debugPrint(dir!.path);

      var stream = yt.videos.streams.get(audio);
      final file = File('${dir.path}/$videoTitle.mp3');

      var fileStream = file.openWrite();

      await stream.pipe(fileStream);
      await fileStream.flush;
      await fileStream.close();
      yt.close();

      setState(() => _status = "已經下載完成");
    } catch (e) {
      setState(() => _status = '錯誤: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
