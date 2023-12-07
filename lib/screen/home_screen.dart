import 'package:flutter/material.dart';
import '../service/spotify.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<dynamic> topArtist = [];
List<dynamic> topSong = [];

void playSong(String id) {
  Spotify.playSong(id);
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Spotify.authorize();
    Spotify.getTopArtist().then((value) {
      List<dynamic> artists = (value as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      setState(() {
        topArtist = artists;
      });
    });
    Spotify.getTopSong().then((value) {
      List<dynamic> song = (value as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      setState(() {
        topSong = song;
      });
    });
  }

  void getListening() async {
    var anime = await SpotifySdk.getPlayerState();
    print(anime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff121212),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_music), label: 'Library'),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
      backgroundColor: const Color(0xff121212),
      body: Padding(
          padding: const EdgeInsets.only(
            top: 50,
            left: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Your Top Artist",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              topArtists(),
              const SizedBox(
                height: 20,
              ),
              const Text("Your Top Song",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              topSongs(),
            ],
          )),
    );
  }
}

Widget artistsBuilder() {
  return ListView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    itemCount: topArtist.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  image: DecorationImage(
                    image: NetworkImage(
                        topArtist[index]["images"][0]["url"].toString()),
                    fit: BoxFit.cover,
                  ),
                  color: const Color(0xff212121)),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              topArtist[index]["name"].toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget songsBuilder() {
  return ListView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    itemCount: topSong.length,
    itemBuilder: (context, index) {
      return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            playSong(topSong[index]["id"].toString());
          },
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    image: DecorationImage(
                      image: NetworkImage(topSong[index]["album"]["images"][0]
                              ["url"]
                          .toString()),
                      fit: BoxFit.cover,
                    ),
                    color: const Color(0xff212121)),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                topSong[index]["name"].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget topArtists() {
  return SizedBox(
    height: 150,
    child: NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator(); // Prevent overscroll indicator
        return true;
      },
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [
              Colors.transparent,
              Colors.white,
              Colors.white,
              Colors.transparent,
            ],
            stops: [0.0, 0.1, 0.9, 1.0],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: artistsBuilder(),
      ),
    ),
  );
}

Widget topSongs() {
  return SizedBox(
    height: 150,
    child: NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator(); // Prevent overscroll indicator
        return true;
      },
      child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white,
                Colors.white,
                Colors.transparent,
              ],
              stops: [0.0, 0.1, 0.9, 1.0],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: songsBuilder()),
    ),
  );
}
