import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer audioPlayer = AudioPlayer();
  
  Future<void> initAudio(String filePath) async {
    try {
      await audioPlayer.setFilePath(filePath);
    } catch (e) {
      debugPrint("音樂初始化失敗");
    }
  }
  
  Future<void> play() async {
    await audioPlayer.play();
  }
  
  Future<void> pause() async {
    await audioPlayer.pause();
  }
  
  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
  }
  
  Future<void> dispose() async {
    await audioPlayer.dispose();
  }
  
  Stream<Duration?> get durationStream => audioPlayer.durationStream;
  Stream<Duration> get positionStream => audioPlayer.positionStream;
  Stream<PlayerState> get playerStateStream => audioPlayer.playerStateStream;
}