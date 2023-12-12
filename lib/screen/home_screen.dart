import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../service/spotify.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Map<String, dynamic> nowPlaying = {};
Map<String, dynamic> me = {};
List<dynamic> topArtist = [];
List<dynamic> topSong = [];
List<dynamic> recommendedPlaylist = [];
List<dynamic> lastPlayed = [];
bool isPlaying = false;
bool isLoading = true;
double percentage = 0;

void playSong(String id) {
  Spotify.playSong(id);
}

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
      setState(() {
        me = value;
      });
    });
    Spotify.getTopArtist().then((value) {
      List<dynamic> artists = (value as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      setState(() {
        topArtist = artists;
      });
    });
    Spotify.getRecommendedPlaylist().then((value) {
      List<dynamic> playlist = (value as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      setState(() {
        recommendedPlaylist = playlist;
      });
    });
    Spotify.getLastPlayed().then((value) {
      List<dynamic> last = (value as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      setState(() {
        lastPlayed = last;
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
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (me.isNotEmpty &&
          topArtist.isNotEmpty &&
          topSong.isNotEmpty &&
          recommendedPlaylist.isNotEmpty &&
          lastPlayed.isNotEmpty) {
        setState(() {
          isLoading = false;
        });
        Spotify.nowPlaying().then((value) {
          setState(() {
            nowPlaying = value;
            isPlaying = nowPlaying['is_playing'];
            percentage = songProgress();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
          backgroundColor: Colors.transparent,
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
      ),
      backgroundColor: const Color(0xff121212),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.waveDots(
                  color: Colors.white, size: 50))
          : SizedBox(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 50),
                          child: meWidget(),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          height: 330,
                          child: lastPlayedHeroBuilder(),
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
                        topArtists(),
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
                        topSongs(),
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
                        recPlaylist(),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                  nowPlaying.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.only(bottom: 52),
                          alignment: Alignment.bottomCenter,
                          child: musicController(),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
    );
  }
}

Widget lastPlayedHeroBuilder() {
  return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: lastPlayed.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisExtent: 75),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xff212121)),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: NetworkImage(lastPlayed[index]["track"]["album"]
                                ["images"][0]["url"]
                            .toString()),
                        fit: BoxFit.cover,
                      ),
                      color: const Color(0xff212121)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    lastPlayed[index]["track"]["name"].toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        );
      });
}

Widget artistsBuilder() {
  return ListView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    itemCount: topArtist.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            playSong(topArtist[index]["uri"].toString());
          },
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
            playSong(topSong[index]["uri"].toString());
          },
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
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

Widget rPlaylistBuilder() {
  return ListView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    itemCount: recommendedPlaylist.length,
    itemBuilder: (context, index) {
      return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            playSong(recommendedPlaylist[index]["uri"].toString());
          },
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: NetworkImage(recommendedPlaylist[index]["images"]
                              [0]["url"]
                          .toString()),
                      fit: BoxFit.cover,
                    ),
                    color: const Color(0xff212121)),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                recommendedPlaylist[index]["name"].toString(),
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
  return Container(
    padding: const EdgeInsets.only(left: 20),
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
  return Container(
    padding: const EdgeInsets.only(left: 20),
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

Widget recPlaylist() {
  return Container(
    padding: const EdgeInsets.only(left: 20),
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
          child: rPlaylistBuilder()),
    ),
  );
}

Widget musicController() {
  return Container(
    height: 60,
    margin: const EdgeInsets.all(5),
    padding: const EdgeInsets.only(left: 5, right: 5),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 91, 91, 91),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xff212121),
                    image: DecorationImage(
                      image: NetworkImage(nowPlaying["item"]["album"]["images"]
                              [0]["url"]
                          .toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        nowPlaying["item"]["name"].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.speaker,
                            color: Color.fromARGB(255, 30, 215, 96), size: 13),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            nowPlaying["item"]["artists"][0]["name"].toString(),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 30, 215, 96),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.monitor,
                    color: Color.fromARGB(255, 30, 215, 96),
                  ),
                ),
                const SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.check_circle,
                    color: Color.fromARGB(255, 30, 215, 96),
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: isPlaying
                      ? InkWell(
                          splashColor: Colors.black,
                          onTap: () {
                            Spotify.pauseSong();
                          },
                          child: const Icon(
                            Icons.pause,
                            color: Colors.white,
                          ),
                        )
                      : InkWell(
                          splashColor: Colors.black,
                          onTap: () {
                            Spotify.resumeSong();
                          },
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 2,
            width: double.infinity,
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: const Color(0xff212121),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 30, 215, 96)),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget meWidget() {
  return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: const Color(0xff212121),
            image: DecorationImage(
              image: NetworkImage(me["images"][0]["url"].toString()),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          me["display_name"].toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        )
      ]);
}
