import 'package:flutter/material.dart';
import '../services/youtube_download_service.dart';

class AudioDownload extends StatefulWidget {
  const AudioDownload({super.key});

  @override
  State<AudioDownload> createState() => _AudioDownloadState();
}

class _AudioDownloadState extends State<AudioDownload> {
  final TextEditingController _urlController = TextEditingController();
  final YoutubeDownloadService _downloadService = YoutubeDownloadService();
  String _status = ''; //指示
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    _downloadService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }

  Future<void> _download(String url) async {
    if (url.isEmpty) {
      setState(() => _status = '請輸入網址');
      return;
    }

    setState(() {
      _isLoading = true;
      _status = '準備下載...';
    });

    try {
      final result = await _downloadService.downloadAudio(
        url, 
        (status) => setState(() => _status = status)
      );
      
      setState(() => _status = result);
    } finally {
      setState(() => _isLoading = false);
      Navigator.pop(context);
    }
  }
}
