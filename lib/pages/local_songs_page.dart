import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rag_rang_app/pages/song_player_page.dart';

class LocalSongsPage extends StatefulWidget {
  const LocalSongsPage({super.key});

  @override
  State<LocalSongsPage> createState() => _LocalSongsPageState();
}

class _LocalSongsPageState extends State<LocalSongsPage> {
  List<File> _songs = [];

  @override
  void initState() {
    super.initState();
    requestPermissionAndFetchSongs();
  }

  Future<void> requestPermissionAndFetchSongs() async {
    var storage = await Permission.storage.request();
    var manage = await Permission.manageExternalStorage.request();

    if (storage.isGranted || manage.isGranted) {
      fetchAllSongs();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission denied to read files.")),
      );
      openAppSettings();
    }
  }

  Future<void> fetchAllSongs() async {
    List<File> foundSongs = [];
    List<String> folders = [
      "/storage/emulated/0/Music",
      "/storage/emulated/0/Download",
      "/storage/emulated/0/Documents",
      "/storage/emulated/0",
    ];

    for (String path in folders) {
      final dir = Directory(path);
      if (await dir.exists()) {
        try {
          final files = dir.listSync(recursive: true);
          for (var file in files) {
            if (file is File && file.path.toLowerCase().endsWith(".mp3")) {
              foundSongs.add(file);
            }
          }
        } catch (_) {}
      }
    }

    setState(() {
      _songs = foundSongs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[200],
      body: _songs.isEmpty
          ? Center(
        child: Text(
          "No songs found in storage.",
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.black54,
            fontSize: 16,
          ),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _songs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final file = _songs[index];
          final fileName = file.path.split('/').last;

          return Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: const Icon(Icons.music_note,
                  color: Colors.deepPurple, size: 30),
              title: Text(
                fileName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              trailing: IconButton(
                icon:
                const Icon(Icons.play_arrow, color: Colors.deepPurple),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SongPlayerPage(
                        title: fileName,
                        artist: 'Unknown Artist',
                        imageUrl: '',
                        songUrl: file.path,
                        songId: file.path, // ✅ use path as unique ID
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
