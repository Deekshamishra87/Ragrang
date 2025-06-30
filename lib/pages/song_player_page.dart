import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:rag_rang_app/widgets/like_storage.dart';
import 'package:rag_rang_app/song_model.dart'; // Import SongModel

class SongPlayerPage extends StatefulWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final String songUrl;
  final String songId;

  const SongPlayerPage({
    super.key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.songUrl,
    required this.songId,
  });

  @override
  State<SongPlayerPage> createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends State<SongPlayerPage> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = true;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    _playSong();

    _player.onDurationChanged.listen((d) => setState(() => _duration = d));
    _player.onPositionChanged.listen((p) => setState(() => _position = p));
  }

  void _playSong() async {
    if (widget.songUrl.startsWith('http')) {
      await _player.play(UrlSource(widget.songUrl));
    } else {
      await _player.play(DeviceFileSource(widget.songUrl));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎵 Now Playing: ${widget.title}'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.deepPurple,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.resume();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  String _formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}';
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLiked = LikeStorage.isLiked(widget.songId);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: widget.imageUrl.isNotEmpty &&
                    widget.imageUrl.startsWith('http')
                    ? Image.network(
                  widget.imageUrl,
                  width: 260,
                  height: 260,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/local.png',
                    width: 260,
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                )
                    : Image.asset(
                  'assets/images/local.png',
                  width: 260,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                widget.artist.isNotEmpty ? widget.artist : "Unknown Artist",
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.redAccent,
                  size: 30,
                ),
                onPressed: () {
                  final song = SongModel(
                    id: widget.songId,
                    title: widget.title,
                    artist: widget.artist,
                    imageUrl: widget.imageUrl,
                    previewUrl: widget.songUrl,
                  );

                  setState(() {
                    LikeStorage.toggleLike(song);
                  });
                },
              ),
              const SizedBox(height: 20),
              Slider(
                value: _position.inSeconds.toDouble(),
                max: _duration.inSeconds.toDouble() + 1,
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await _player.seek(position);
                },
                activeColor: Colors.white,
                inactiveColor: Colors.white30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatTime(_position),
                      style: const TextStyle(color: Colors.white70)),
                  Text(_formatTime(_duration),
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 20),
              IconButton(
                iconSize: 80,
                color: Colors.white,
                icon: Icon(_isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill),
                onPressed: _togglePlayPause,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
