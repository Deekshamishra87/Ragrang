import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rag_rang_app/notifiers.dart';
import 'package:rag_rang_app/widgets/like_storage.dart';
import 'package:rag_rang_app/song_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _songs = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    fetchSongs("bollywood");
  }

  Future<void> fetchSongs(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = Uri.parse('https://itunes.apple.com/search?term=$query&media=music');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _songs = data['results'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Error: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to fetch songs: $e";
        _isLoading = false;
      });
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search by artist or track...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => fetchSongs(_controller.text.trim()),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                ),
                onSubmitted: fetchSongs,
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red))
            else if (_songs.isEmpty)
                Text(
                  'No results found. Try another search!',
                  style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: _songs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final song = _songs[index];
                      final String id = (song['trackId'] ?? song['previewUrl']).toString();
                      final String title = song['trackName'] ?? 'Unknown Track';
                      final String artist = song['artistName'] ?? 'Unknown Artist';
                      final String imageUrl = (song['artworkUrl100'] ?? '').replaceAll('100x100', '600x600');
                      final String previewUrl = song['previewUrl'] ?? '';

                      final SongModel songModel = SongModel(
                        id: id,
                        title: title,
                        artist: artist,
                        imageUrl: imageUrl,
                        previewUrl: previewUrl,
                      );

                      final isLiked = LikeStorage.isLiked(id);

                      return Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[900] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.music_note, size: 40),
                            ),
                          ),
                          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(artist, style: const TextStyle(color: Colors.grey)),
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
                                      content: Text(
                                        isLiked ? 'Removed from Likes' : 'Added to Likes',
                                      ),
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
