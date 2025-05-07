import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:io';

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
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
        ),
      ),
    );
  }

  Future<void> _download(String url) async {
    setState(() {
      _isLoading = true;
      _status = '開始下載，請勿關閉...';
    });

    try {

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
      Navigator.pop(context);
    }
  }
}
