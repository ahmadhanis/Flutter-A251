import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyPlayer());
  }
}

class MyPlayer extends StatefulWidget {
  const MyPlayer({super.key});

  @override
  State<MyPlayer> createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyPlayer> {
  late AudioPlayer player = AudioPlayer();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Player')),
      body: Center(
        child: Column(
          children: [
            IconButton(onPressed: playMe, icon: Icon(Icons.play_arrow)),
          ],
        ),
      ),
    );
  }

  void playMe() {
    player.play(AssetSource('bell.mp3'));
  }
}
