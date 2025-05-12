import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../services/audio_player_service.dart';

class PlayerScreen extends StatefulWidget {
  final String filePath;
  final List<String> fileNameList;
  final int nowIndex;

  const PlayerScreen({
    super.key,
    required this.filePath,
    required this.fileNameList,
    required this.nowIndex
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late String targetDir;
  late int playerlistIndex;
  late List<String> playlist;

  final AudioPlayerService _audioService = AudioPlayerService();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  bool _isPlaying = false;
  bool _isReplay = false;

  @override
  void initState() {
    super.initState();
    targetDir = widget.filePath;
    playerlistIndex = widget.nowIndex;
    playlist = widget.fileNameList;

    _initPlayer();

    _audioService.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (!_isReplay) {
          setState(() {
            playerlistIndex = (playerlistIndex == playlist.length - 1)
                ? 0
                : playerlistIndex + 1;
          });
        }
        _initPlayer();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _audioService.dispose();
  }

  Future<void> _initPlayer() async {
    await _audioService.initAudio("$targetDir/${playlist[playerlistIndex]}");
    
    _audioService.durationStream.listen((d) {
      setState(() => _duration = d ?? Duration.zero);
    });
    
    _audioService.positionStream.listen((p) {
      setState(() => _position = p);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
