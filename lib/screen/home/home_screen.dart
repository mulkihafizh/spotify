import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../service/spotify.dart';
import 'dart:async';
import '../../components/home/last_played_hero.dart';
import '../../components/home/just_for_you.dart';
import '../../components/home/top_artist.dart';
import '../../components/home/top_songs.dart';

import '../../components/home/me.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Map<String, dynamic> me = {};
List<dynamic> topArtist = [];
List<dynamic> topSong = [];
List<dynamic> recommendedPlaylist = [];
List<dynamic> lastPlayed = [];
bool isPlaying = false;
bool isLoading = true;
double percentage = 0;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Spotify.checkValidity().then((value) {
      if (!value) {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    Spotify.authorize();
    Spotify.me().then((value) {
      if (mounted) {
        setState(() {
          me = value;
        });
      }
    });
    Spotify.getTopArtist().then((value) {
      List<dynamic> artists = (value as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      if (mounted) {
        setState(() {
          topArtist = artists;
        });
      }
    });
    Spotify.getRecommendedPlaylist().then((value) {
      List<dynamic> playlist = (value as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      if (mounted) {
        setState(() {
          recommendedPlaylist = playlist;
        });
      }
    });
    Spotify.getLastPlayed().then((value) {
      List<dynamic> last = (value as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      if (mounted) {
        setState(() {
          lastPlayed = last;
        });
      }
    });
    Spotify.getTopSong().then((value) {
      List<dynamic> song = (value as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      if (mounted) {
        setState(() {
          topSong = song;
        });
      }
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (me.isNotEmpty &&
          topArtist.isNotEmpty &&
          topSong.isNotEmpty &&
          recommendedPlaylist.isNotEmpty &&
          lastPlayed.isNotEmpty) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.waveDots(
                  color: Colors.white, size: 50))
          : SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 50),
                  child: meWidget(me),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  height: 330,
                  child: lastPlayedHeroBuilder(lastPlayed),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text("Your Top Artist",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 20,
                ),
                topArtists(topArtist),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text("Your Top Song",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 20,
                ),
                topSongs(topSong),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text("Just For You",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 20,
                ),
                recPlaylist(recommendedPlaylist),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
    );
  }
}
