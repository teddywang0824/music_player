import 'package:flutter/material.dart';

class MusicList extends StatelessWidget {
  const MusicList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("我的音樂"),
            leading: const Icon(Icons.music_note),
            trailing: const Icon(Icons.play_arrow),
            onTap: (){},
            onLongPress: (){},
          );
        });
  }
}
