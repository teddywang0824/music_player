import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'player.dart';
import '../services/file_service.dart';

class MusicList extends StatefulWidget {
  const MusicList({super.key});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  final FileService _fileService = FileService();
  List<String> fileNames = [];
  String states = "讀取中...";
  StreamSubscription<FileSystemEvent>? _dirSreamSubscription;

  @override
  void initState() {
    super.initState();
    _loadFileNames();
    _startDirWatch();
  }

  @override
  void dispose() {
    _fileService.cancelDirectoryWatch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return fileNames.isEmpty
        ? Center(child: Text(states))
        : ListView.builder(
            itemCount: fileNames.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(fileNames[index]),
                leading: const Icon(Icons.music_note),
                trailing: const Icon(Icons.play_arrow),
                onTap: () async {
                  var dir = await _fileService.getDirectoryPath();
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => PlayerScreen(
                        filePath: dir, 
                        fileNameList: fileNames, 
                        nowIndex: index
                      )
                    )
                  );
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        children: [
                          SimpleDialogOption(
                            child: const Text("刪除音樂"),
                            onPressed: () {
                              _deleteIndex(index);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    }
                  );
                },
              );
            },
          );
  }

  Future<void> _loadFileNames() async {
    try {
      List<String> names = await _fileService.loadFileNames();
      setState(() {
        fileNames = names;
        states = names.isEmpty ? "資料夾中沒有檔案" : "檔案讀取完成";
      });
    } catch (e) {
      setState(() => states = "發生錯誤 : $e");
    }
  }

  Future<void> _startDirWatch() async {
    _dirSreamSubscription = await _fileService.watchDirectory(_loadFileNames);
  }

  Future<void> _deleteIndex(int index) async {
    try {
      await _fileService.deleteFile(fileNames[index]);
      // 文件監視器會自動觸發重新加載
    } catch (e) {
      setState(() => states = e.toString());
    }
  }
}