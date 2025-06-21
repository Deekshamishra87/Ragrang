import 'package:flutter/material.dart';
import 'package:rag_rang_app/pages/home_page.dart';
import 'package:rag_rang_app/pages/song_player_page.dart';
import 'package:rag_rang_app/pages/like_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rag_rang_app/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  static const Color listViewBgColor = Color(0xFFE0E0E0); // Grey color for background

  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentSongNotifier,
      builder: (context, songData, _) {
        final List<Widget> pages = [
          const HomePage(),
          songData.isNotEmpty
              ? SongPlayerPage(
            title: songData['title']!,
            artist: songData['artist']!,
            songPath: songData['path']!,
          )
              : const HomePage(), // If no song playing, show HomePage
          const LikePage(),
        ];

        final bool isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: listViewBgColor,  // Background same as listview color
          appBar: AppBar(
            backgroundColor:isDark ? Colors.purpleAccent.withOpacity(0.3) : Colors.white,
            // AppBar same grey background, no shadow
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () async {
                  isbrightNotifier.value = !isbrightNotifier.value;
                  final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  await prefs.setBool(kconstants.themeModekey, isbrightNotifier.value);
                },
                icon: ValueListenableBuilder(
                  valueListenable: isbrightNotifier,
                  builder: (context, value, child) {
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
                final text = value == 0
                    ? 'Music'
                    : value == 1
                    ? 'Now Playing'
                    : 'Likes';

                return Shimmer.fromColors(
                  baseColor: isDark ? Colors.white : Colors.black,
                  highlightColor: isDark ? Colors.purpleAccent : Colors.purpleAccent,
                  child: Text(
                    text,
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
            builder: (context, value, _) {
              return pages[value];
            },
          ),
          bottomNavigationBar: ValueListenableBuilder(
            valueListenable: selectedvalueNotifier,
            builder: (context, selected, _) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // SHIMMER BORDER LAYER
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

                    // MAIN NAVIGATION BAR
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
                            iconTheme: MaterialStateProperty.resolveWith<IconThemeData>(
                                  (states) => IconThemeData(
                                color: Colors.black,
                              ),
                            ),
                            labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                                  (states) => const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          child: NavigationBar(
                            height: 65,
                            backgroundColor: isDark ? Colors.purple[200] : Colors.white,
                            indicatorColor:
                            Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                            elevation: 0,
                            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                            destinations: const [
                              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                              NavigationDestination(
                                  icon: Icon(Icons.music_note), label: 'Now Playing'),
                              NavigationDestination(icon: Icon(Icons.favorite), label: 'Like'),
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
