import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerScreen extends StatefulWidget {
  final String filePath;
  final List<String> fileNameList;
  final int nowIndex;

  const PlayerScreen(
      {super.key,
      required this.filePath,
      required this.fileNameList,
      required this.nowIndex});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late String targetDir;
  late int playerlistIndex;
  late List<String> playlist;

  late AudioPlayer _audioPlayer;
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
    _audioPlayer = AudioPlayer();

    _iniAudio();

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (!_isReplay) {
          setState(() {
            playerlistIndex = (playerlistIndex == playlist.length - 1)
                ? 0
                : playerlistIndex + 1;
          });
        }
        _iniAudio();
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("音樂撥放器"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            playlist[playerlistIndex],
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Slider(
            value: _position.inSeconds.toDouble(),
            max: _duration.inSeconds.toDouble(),
            onChanged: (double value) async {
              final position = Duration(seconds: value.toInt());
              await _audioPlayer.seek(position);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(_position)),
              Text(_formatDuration(_duration)),
            ],
          ),
          Stack(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isReplay = !_isReplay;
                    });
                  },
                  icon: _isReplay ? const Icon(Icons.replay_circle_filled) : const Icon(Icons.replay)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          playerlistIndex = (playerlistIndex == 0)
                              ? playlist.length - 1
                              : playerlistIndex - 1;
                        });
                        _iniAudio();
                      },
                      icon: const Icon(Icons.skip_previous)),
                  IconButton(
                      onPressed: () async {
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                        if (_isPlaying) {
                          await _audioPlayer.play();
                        } else {
                          await _audioPlayer.pause();
                        }
                      },
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          playerlistIndex =
                              (playerlistIndex == playlist.length - 1)
                                  ? 0
                                  : playerlistIndex + 1;
                        });
                        _iniAudio();
                      },
                      icon: const Icon(Icons.skip_next)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _iniAudio() async {
    try {
      await _audioPlayer.setFilePath("$targetDir/${playlist[playerlistIndex]}");
      _audioPlayer.durationStream.listen((d) {
        setState(() => _duration = d ?? Duration.zero);
      });
      _audioPlayer.positionStream.listen((p) {
        setState(() => _position = p);
      });
    } catch (e) {
      debugPrint("音樂初始化失敗");
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds % 60);

    return "$minutes:$seconds";
  }
}
