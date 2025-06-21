import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SongPlayerPage extends StatefulWidget {
  const SongPlayerPage({
    super.key,
    required this.title,
    required this.artist,
    required this.songPath,
  });

  final String title;
  final String artist;
  final String songPath;

  @override
  State<SongPlayerPage> createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends State<SongPlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playSong();
  }

  void _playSong() async {
    await _audioPlayer.play(DeviceFileSource(widget.songPath));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade400, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Album Art
                CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage(
                      'assets/album_art.jpg'), // Replace with your asset or use NetworkImage
                ),
                const SizedBox(height: 30),
      
                // Title
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
      
                // Artist
                Text(
                  widget.artist,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
      
                const SizedBox(height: 40),
      
                // Seek Bar (dummy for now)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Slider(
                    value: 0,
                    onChanged: (value) {},
                    min: 0,
                    max: 100,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                  ),
                ),
      
                const SizedBox(height: 30),
      
                // Play/Pause Button
                IconButton(
                  icon: const Icon(
                    Icons.pause_circle_filled,
                    size: 64,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _audioPlayer.pause(); // You can toggle with isPlaying later
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
