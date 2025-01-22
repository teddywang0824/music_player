import 'package:flutter/material.dart';
import 'view/musiclist.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Music List",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.add)),
        ],
      ),
      body: AudioDownload(),
    );
  }
}

class AudioDownload extends StatefulWidget {
  const AudioDownload({super.key});

  @override
  State<AudioDownload> createState() => _AudioDownloadState();
}

class _AudioDownloadState extends State<AudioDownload> {
  final TextEditingController _urlController = TextEditingController();
  String _status = '';

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _urlController,
          decoration: const InputDecoration(
            labelText: '輸入 Youtube 網址',
          ),
        ),
        const SizedBox(height: 20,),
        ElevatedButton(onPressed: (){
          _testPathProvider();
          debugPrint("-----你輸入的是 ${_urlController.text}-----");
          setState(() {
            _status = '喔是喔';
          });
        }, child: const Text("送出")),
        Text(_status),
      ],
    );
  }

  Future<void> _testPathProvider() async {
    var dir = await getApplicationDocumentsDirectory();
    debugPrint("---${dir.path}---");
  }
}
