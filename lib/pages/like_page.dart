import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rag_rang_app/song_model.dart'; // import your model
import 'package:rag_rang_app/notifiers.dart';  // for currentSongNotifier, selectedvalueNotifier

class LikePage extends StatelessWidget {
  const LikePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<SongModel>>(
      valueListenable: Hive.box<SongModel>('liked_songs').listenable(),
      builder: (context, box, _) {
        final likedSongs = box.values.toList();

        if (likedSongs.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text('No liked songs yet!', style: TextStyle(fontSize: 18)),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('❤️ Liked Songs')),
          body: ListView.separated(
            itemCount: likedSongs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final song = likedSongs[index];
              return ListTile(
                leading: Image.network(
                  song.imageUrl,
                  width: 50,
                  height: 50,
                  errorBuilder: (_, __, ___) => const Icon(Icons.music_note),
                ),
                title: Text(song.title),
                subtitle: Text(song.artist),
                trailing: IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {
                    currentSongNotifier.value = {
                      'title': song.title,
                      'artist': song.artist,
                      'path': song.previewUrl,
                      'image': song.imageUrl,
                    };
                    selectedvalueNotifier.value = 1;
                  },
                ),
                onLongPress: () {
                  box.delete(song.id); // remove from liked
                },
              );
            },
          ),
        );
      },
    );
  }
}
