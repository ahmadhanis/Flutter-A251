import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: AppBarTheme(backgroundColor: Colors.deepOrange),
      ),
      home: MyPlayer(),
    );
  }
}

class MyPlayer extends StatefulWidget {
  const MyPlayer({super.key});

  @override
  State<MyPlayer> createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyPlayer> {
  late AudioPlayer player = AudioPlayer();
  AudioCache audioCache = AudioCache();
  String status = 'Not Playing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Player')),
      body: Center(
        child: Column(
          children: [
            Text(
              'Playing Audio from Assets',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    iconSize: 48,
                    onPressed: stopMe,
                    icon: Icon(Icons.stop),
                  ),
                  IconButton(
                    iconSize: 48,
                    onPressed: playMe,
                    icon: Icon(Icons.play_arrow),
                  ),
                  IconButton(
                    iconSize: 48,
                    onPressed: pauseMe,
                    icon: Icon(Icons.pause),
                  ),
                ],
              ),
            ),
            Text(status),
            const SizedBox(height: 20),
            Text(
              'Playing from online URL',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    iconSize: 48,
                    onPressed: stopMe,
                    icon: Icon(Icons.stop),
                  ),
                  IconButton(
                    iconSize: 48,
                    onPressed: playMeURL,
                    icon: Icon(Icons.play_arrow),
                  ),
                  IconButton(
                    iconSize: 48,
                    onPressed: pauseMe,
                    icon: Icon(Icons.pause),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void playMe() {
    player.play(AssetSource('sonne.mp3'));
    setState(() {
      status = 'Playing';
    });
  }

  void stopMe() {
    player.stop();
    setState(() {
      status = 'Stop';
    });
  }

  void pauseMe() {
    player.pause();
    setState(() {
      status = 'Pause';
    });
  }

  void playMeURL() {
    player.play(UrlSource('https://slumberjer.com/mysong/sonne.mp3'));
    setState(() {
      status = 'Playing from URL';
    });
  }
}
