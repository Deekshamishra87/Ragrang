import 'package:flutter/material.dart';
import 'package:rag_rang_app/pages/home_page.dart';
import 'package:rag_rang_app/pages/song_player_page.dart';
import 'package:rag_rang_app/pages/like_page.dart';
import 'package:rag_rang_app/pages/local_songs_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rag_rang_app/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  static const Color listViewBgColor = Color(0xFFE0E0E0);

  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder(
      valueListenable: currentSongNotifier,
      builder: (context, songData, _) {
        final List<Widget> pages = [
          const HomePage(),
          songData.isNotEmpty
              ? SongPlayerPage(
            title: songData['title'] ?? 'Unknown',
            artist: songData['artist'] ?? 'Unknown',
            imageUrl: songData['image'] ?? '',
            songUrl: songData['path'] ?? '',
            songId: songData['trackId']?.toString() ?? songData['path'] ?? '',
          )
              : const HomePage(),
          const LikePage(),
          const LocalSongsPage(),
        ];

        return Scaffold(
          backgroundColor: listViewBgColor,
          appBar: AppBar(
            backgroundColor: isDark ? Colors.purpleAccent.withOpacity(0.3) : Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () async {
                  isbrightNotifier.value = !isbrightNotifier.value;
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool(kconstants.themeModekey, isbrightNotifier.value);
                },
                icon: ValueListenableBuilder(
                  valueListenable: isbrightNotifier,
                  builder: (context, value, _) {
                    return Icon(
                      value ? Icons.dark_mode : Icons.light_mode,
                      color: isDark ? Colors.white : Colors.black,
                    );
                  },
                ),
              ),
            ],
            title: ValueListenableBuilder(
              valueListenable: selectedvalueNotifier,
              builder: (context, value, _) {
                final titles = ['Music', 'Now Playing', 'Likes', 'Downloads'];
                return Shimmer.fromColors(
                  baseColor: isDark ? Colors.white : Colors.black,
                  highlightColor: Colors.purpleAccent,
                  child: Text(
                    titles[value],
                    style: const TextStyle(
                      letterSpacing: 2.0,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
          body: ValueListenableBuilder(
            valueListenable: selectedvalueNotifier,
            builder: (context, value, _) => pages[value],
          ),
          bottomNavigationBar: ValueListenableBuilder(
            valueListenable: selectedvalueNotifier,
            builder: (context, selected, _) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.purpleAccent.withOpacity(0.3),
                      highlightColor: isDark ? Colors.grey : Colors.white,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          border: Border.all(
                            color: Colors.purpleAccent.withOpacity(0.6),
                            width: 4,
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purpleAccent,
                          borderRadius: BorderRadius.circular(70),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purpleAccent.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: NavigationBarTheme(
                          data: NavigationBarThemeData(
                            iconTheme: MaterialStateProperty.all(
                                const IconThemeData(color: Colors.black)),
                            labelTextStyle: MaterialStateProperty.all(
                              const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          child: NavigationBar(
                            height: 65,
                            backgroundColor: isDark ? Colors.purple[200] : Colors.white,
                            indicatorColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                            elevation: 0,
                            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                            destinations: const [
                              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                              NavigationDestination(icon: Icon(Icons.music_note), label: 'Now Playing'),
                              NavigationDestination(icon: Icon(Icons.favorite), label: 'Like'),
                              NavigationDestination(icon: Icon(Icons.download), label: 'Downloads'),
                            ],
                            selectedIndex: selected,
                            onDestinationSelected: (index) {
                              selectedvalueNotifier.value = index;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
