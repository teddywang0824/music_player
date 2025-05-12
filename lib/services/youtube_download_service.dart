import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:io';

class YoutubeDownloadService {
  final YoutubeExplode _yt = YoutubeExplode();
  
  Future<String> downloadAudio(String url, Function(String) updateStatus) async {
    try {
      updateStatus('獲取影片資訊...');
      
      final video = await _yt.videos.get(url);
      final videoTitle = video.title;

      var manifest = await _yt.videos.streams.getManifest(url);
      var audio = manifest.audioOnly.withHighestBitrate();

      var dir = await getExternalStorageDirectory();
      updateStatus('下載中，請勿關閉...');
      debugPrint(dir!.path);

      var stream = _yt.videos.streams.get(audio);
      final file = File('${dir.path}/$videoTitle.mp3');

      var fileStream = file.openWrite();

      await stream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();
      
      _yt.close();
      
      return "已經下載完成";
    } catch (e) {
      return '錯誤: $e';
    }
  }
  
  void dispose() {
    _yt.close();
  }
}