import 'dart:io';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'package:rag_rang_app/notifiers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FileSystemEntity> songs = [];
  List<FileSystemEntity> filteredSongs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    requestPermissionAndFetchSongs();
  }

  Future<void> requestPermissionAndFetchSongs() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      await fetchSongsFromDownloadFolder();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchSongsFromDownloadFolder() async {
    try {
      final downloadPath = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOAD);
      final dir = Directory(downloadPath);
      final List<FileSystemEntity> files = dir.listSync();
      final List<FileSystemEntity> mp3Files = files.where((file) => file.path.endsWith(".mp3")).toList();

      setState(() {
        songs = mp3Files;
        filteredSongs = mp3Files;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterSongs(String query) {
    final results = songs.where((file) {
      final name = file.path.split('/').last.toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredSongs = results;
    });
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    await fetchSongsFromDownloadFolder();

  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.purple[50],

      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        springAnimationDurationInMilliseconds: 50,
        color: Colors.purple,
        backgroundColor: isDark ? Colors.grey[900]! : Colors.purple[50]!,
        height: 250,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            children: [
              // Search Bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : Colors.purple.shade200,
                    width: 1,
                  ),
                ),
                child: TextField(
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.purple[900],
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search,
                        color: isDark ? Colors.purple[200] : Colors.purple[400]),
                    hintText: "Search Songs...",
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white38 : Colors.purple[300],
                      fontStyle: FontStyle.italic,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                  ),
                  onChanged: (value) => filterSongs(value),
                ),
              ),

              const SizedBox(height: 14),

              // Song List
              Expanded(
                child: isLoading
                    ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.purple[400],
                  ),
                )
                    : filteredSongs.isEmpty
                    ? Center(
                  child: Text(
                    "No MP3 songs found.",
                    style: TextStyle(
                      fontSize: 15,
                      color:
                      isDark ? Colors.white54 : Colors.purple[300],
                    ),
                  ),
                )
                    : ListView.separated(
                  itemCount: filteredSongs.length,
                  separatorBuilder: (_, __) => Divider(
                    color: isDark
                        ? Colors.grey[700]
                        : Colors.purple.shade100,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  itemBuilder: (context, index) {
                    String fileName =
                        filteredSongs[index].path.split('/').last;

                    return ListTile(
                      leading: Icon(
                        Icons.music_note,
                        color: isDark ? Colors.purple[300] : Colors.purple,
                      ),
                      title: Text(
                        fileName,
                        style: TextStyle(
                          color:
                          isDark ? Colors.white70 : Colors.purple[900],
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.play_arrow,
                            color:
                            isDark ? Colors.purple[300] : Colors.purple),
                        onPressed: () {
                          String filePath = filteredSongs[index].path;
                          currentSongNotifier.value = {
                            'title': fileName,
                            'artist': 'Unknown',
                            'path': filePath,
                          };
                          selectedvalueNotifier.value = 1;
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
