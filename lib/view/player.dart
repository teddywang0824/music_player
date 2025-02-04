import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
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
            "歌曲名",
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Slider(
            value: 0.5,
            onChanged: (double value) {},
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("00:00"),
              Text("00:00"),
            ],
          ),
          Stack(
            children: [
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.replay_circle_filled)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.skip_previous)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.pause)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.skip_next)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
