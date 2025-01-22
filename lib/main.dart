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

class AudioDownload extends StatelessWidget {
  AudioDownload({super.key});
  final TextEditingController _urlController = TextEditingController();

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
        TextButton(onPressed: (){
          _testPathProvider();
          debugPrint("-----你輸入的是 ${_urlController.text}-----");
        }, child: const Text("送出")),
      ],
    );
  }
  
  Future<void> _testPathProvider() async {
    var dir = await getApplicationDocumentsDirectory();
    debugPrint("---${dir.path}---");
  }
}
