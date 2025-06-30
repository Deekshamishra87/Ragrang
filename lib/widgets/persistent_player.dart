// widgets/persistent_player.dart
import 'package:flutter/material.dart';
import 'package:rag_rang_app/pages/song_player_page.dart';

class PersistentPlayer extends StatelessWidget {
  final String title;
  final String artist;
  final bool isPlaying;
  final VoidCallback onPlayPauseToggle;
  final VoidCallback onTap;

  const PersistentPlayer({
    super.key,
    required this.title,
    required this.artist,
    required this.isPlaying,
    required this.onPlayPauseToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.music_note, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "$title • $artist",
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: onPlayPauseToggle,
            )
          ],
        ),
      ),
    );
  }
}
