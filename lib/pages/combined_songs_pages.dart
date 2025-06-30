import 'package:flutter/material.dart';
import 'package:rag_rang_app/pages/home_page.dart';       // iTunes API songs
import 'package:rag_rang_app/pages/local_songs_page.dart'; // Offline local songs

class CombinedSongsPage extends StatelessWidget {
  const CombinedSongsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("🎶 RagRang Songs"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.search), text: "Search"),
              Tab(icon: Icon(Icons.download), text: "Downloads"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomePage(),          // Online search tab
            LocalSongsPage(),    // Offline songs tab
          ],
        ),
      ),
    );
  }
}
