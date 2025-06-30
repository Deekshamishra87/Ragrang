import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rag_rang_app/notifiers.dart';
import 'package:rag_rang_app/widgets/like_storage.dart';
import 'package:rag_rang_app/song_model.dart';

class SongSuggestionPage extends StatefulWidget {
  const SongSuggestionPage({super.key});

  @override
  State<SongSuggestionPage> createState() => _SongSuggestionPageState();
}

class _SongSuggestionPageState extends State<SongSuggestionPage> {
  List<dynamic> _songs = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> fetchSongs(String query) async {
    if (query.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('https://itunes.apple.com/search?term=$query&media=music');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _songs = data['results'];
        });
      } else {
        throw Exception('Failed with status code ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching songs: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎵 Explore Songs'),
        backgroundColor: isDark ? Colors.purple[900] : Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search by artist or track...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => fetchSongs(_controller.text.trim()),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onSubmitted: (val) => fetchSongs(val.trim()),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _songs.isEmpty
                  ? const Center(child: Text('Search to see results...'))
                  : ListView.builder(
                itemCount: _songs.length,
                itemBuilder: (context, index) {
                  final song = _songs[index];
                  final String id = (song['trackId'] ?? song['previewUrl']).toString();
                  final String title = song['trackName'] ?? 'Unknown Track';
                  final String artist = song['artistName'] ?? 'Unknown Artist';
                  final String imageUrl = (song['artworkUrl100'] ?? '').replaceAll('100x100', '600x600');
                  final String previewUrl = song['previewUrl'] ?? '';

                  final songModel = SongModel(
                    id: id,
                    title: title,
                    artist: artist,
                    imageUrl: imageUrl,
                    previewUrl: previewUrl,
                  );

                  final isLiked = LikeStorage.isLiked(id);

                  return ListTile(
                    leading: Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      errorBuilder: (_, __, ___) => const Icon(Icons.music_note),
                    ),
                    title: Text(title),
                    subtitle: Text(artist),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            LikeStorage.toggleLike(songModel);
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isLiked ? 'Removed from Likes' : 'Added to Likes'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () {
                            if (previewUrl.isNotEmpty) {
                              currentSongNotifier.value = {
                                'title': title,
                                'artist': artist,
                                'path': previewUrl,
                                'image': imageUrl,
                              };
                              selectedvalueNotifier.value = 1;
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
