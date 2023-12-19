import 'dart:async';

import 'package:flutter/material.dart';
import '../service/spotify.dart';
import 'home/home_screen.dart';
import 'search/search_screen.dart';
import 'profile/profile_screen.dart';
import '../../components/home/music_controller.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Widget> menu = [
    const HomeScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];

  bool isPlaying = false;
  Map<String, dynamic> nowPlaying = {};
  int navIndex = 0;

  songProgress() {
    if (nowPlaying['is_playing']) {
      var progress = nowPlaying['progress_ms'];
      var duration = nowPlaying['item']['duration_ms'];
      var progressPercent = (progress / duration) * 100;
      return progressPercent;
    } else {
      return 0.0;
    }
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      Spotify.nowPlaying().then((value) {
        if (mounted) {
          setState(() {
            nowPlaying = value;
            isPlaying = nowPlaying['is_playing'];
            percentage = songProgress();
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: const Color(0xff121212),
      body: SizedBox(
          child: Stack(children: [
        menu[navIndex],
        nowPlaying.isNotEmpty
            ? Container(
                padding: const EdgeInsets.only(bottom: 52),
                alignment: Alignment.bottomCenter,
                child: musicController(nowPlaying, isPlaying, percentage),
              )
            : const SizedBox(),
      ])),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(167, 0, 0, 0), // Adjust the opacity as needed
            ],
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: navIndex,
          onTap: (index) {
            setState(() {
              navIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.library_music),
                icon: Icon(Icons.library_music_outlined),
                label: 'Library,'),
          ],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
        ),
      ),
    );
  }
}
