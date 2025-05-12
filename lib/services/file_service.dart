import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileService {
  StreamSubscription<FileSystemEvent>? _dirStreamSubscription;
  
  Future<List<String>> loadFileNames() async {
    try {
      var dir = await getExternalStorageDirectory();
      List<FileSystemEntity> files = dir!.listSync();
      List<String> names = files
          .whereType<File>()
          .map((file) => file.path.split('/').last)
          .toList();
      
      return names;
    } catch (e) {
      throw Exception("發生錯誤 : $e");
    }
  }
  
  Future<void> deleteFile(String fileName) async {
    try {
      var dir = await getExternalStorageDirectory();
      final file = File('${dir!.path}/$fileName');
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception("刪除失敗 : $e");
    }
  }
  
  Future<String> getDirectoryPath() async {
    var dir = await getExternalStorageDirectory();
    return dir!.path;
  }
  
  Future<StreamSubscription<FileSystemEvent>> watchDirectory(Function onEvent) async {
    var dir = await getExternalStorageDirectory();
    _dirStreamSubscription = dir!
        .watch(events: FileSystemEvent.all)
        .listen((_) => onEvent());
    
    return _dirStreamSubscription!;
  }
  
  void cancelDirectoryWatch() {
    _dirStreamSubscription?.cancel();
  }
}