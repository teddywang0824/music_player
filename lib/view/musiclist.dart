import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MusicList extends StatefulWidget {
  const MusicList({super.key});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  List<String> fileNames = [];
  String states = '讀取中...';
  late StreamSubscription _dirSreamSubscription;

  @override
  void initState() {
    super.initState();
    _loadFileNames();
    _startDirWatch();
  }

  @override
  void dispose() {
    _dirSreamSubscription.cancel();
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
                onTap: () {},
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
                            SimpleDialogOption(
                              child: const Text("修改音樂名稱"),
                              onPressed: () {
                                TextEditingController _nameController =
                                    TextEditingController(text: fileNames[index]);
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text("請輸入新的名稱"),
                                            TextField(
                                              controller: _nameController,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                _modifyIndex(index,
                                                    _nameController.text);
                                                Navigator.pop(context);
                                              },
                                              child: const Text("修改"),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                                
                              },
                            ),
                          ],
                        );
                      });
                },
              );
            });
  }

  Future<void> _loadFileNames() async {
    try {
      var dir = await getExternalStorageDirectory();

      List<FileSystemEntity> files = dir!.listSync();
      List<String> names = files
          .whereType<File>()
          .map((file) => file.path.split('/').last)
          .toList();

      setState(() {
        fileNames = names;
        states = names.isEmpty ? "資料夾中沒有檔案" : "檔案讀取完成";
      });
    } catch (e) {
      setState(() => states = "發生錯誤 : $e");
    }
  }

  Future<void> _startDirWatch() async {
    var dir = await getExternalStorageDirectory();

    _dirSreamSubscription = dir!
        .watch(events: FileSystemEvent.all)
        .listen((event) => _loadFileNames());
  }

  Future<void> _deleteIndex(int index) async {
    var dir = await getExternalStorageDirectory();
    String name = fileNames[index];
    final file = File('${dir!.path}/$name');

    if (await file.exists()) {
      await file.delete();

      setState(() {
        fileNames.removeAt(index);
      });
    }
  }

  Future<void> _modifyIndex(int index, String newName) async {
    var dir = await getExternalStorageDirectory();
    String name = fileNames[index];
    final file = File('${dir!.path}/$name');

    if (await file.exists()) {
      await file.rename('${dir.path}/$newName');

      setState(() {
        fileNames[index] = newName;
      });
    }
  }
}
