import 'dart:async';
import 'package:flutter/material.dart';
import '../service/spotify.dart';
import 'home/home_screen.dart';
import 'search/search_screen.dart';
import 'profile/profile_screen.dart';
import '../../components/home/music_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

var controller = PanelController();
bool showNav = true;

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
  int progress = 0;
  List<dynamic> lyricsText = [];

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

  void startDuration() {
    Timer.periodic(const Duration(milliseconds: 1), (timer) {
      if (mounted) {
        setState(() {
          progress = progress++;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      Spotify.nowPlaying().then((value) {
        if (mounted) {
          if (nowPlaying["item"]["id"] != value["item"]["id"] ||
              nowPlaying.isNotEmpty) {
            setState(() {
              nowPlaying = value;
              isPlaying = value["is_playing"];
              percentage = songProgress();
            });
          }
        }
      });
      if (isPlaying) {
        Spotify.getLyrics(
          nowPlaying["item"]["id"].toString(),
        ).then((value) {
          if (mounted) {
            setState(() {
              lyricsText = value;
            });
          }
        });
      }
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
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showNav = false;
                    });
                    controller.open();
                  },
                  child: musicController(nowPlaying, isPlaying, percentage),
                ),
              )
            : const SizedBox(),
        nowPlaying.isNotEmpty
            ? nowPlayingWidget(nowPlaying, context)
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
        child: Visibility(
          visible: showNav,
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
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(
                  activeIcon: Icon(Icons.library_music),
                  icon: Icon(Icons.library_music_outlined),
                  label: 'Library,'),
            ],
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget nowPlayingWidget(Map<String, dynamic> nowPlaying, context) {
    return (SlidingUpPanel(
        minHeight: 0,
        onPanelClosed: () => setState(() {
              showNav = true;
            }),
        controller: controller,
        maxHeight: MediaQuery.of(context).size.height,
        panel: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: const Color(0xff121212),
              leading: IconButton(
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    showNav = true;
                  });
                  controller.close();
                },
              ),
              title: const Text(
                'Now Playing',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            backgroundColor: const Color(0xff121212),
            body: Container(
              alignment: AlignmentDirectional.topStart,
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width - 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xff212121),
                          image: DecorationImage(
                            image: NetworkImage(nowPlaying["item"]["album"]
                                    ["images"][0]["url"]
                                .toString()),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        nowPlaying["item"]["name"].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        nowPlaying["item"]["artists"][0]["name"].toString(),
                        style: const TextStyle(
                          color: Color.fromARGB(221, 255, 255, 255),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 3,
                        width: double.infinity,
                        child: LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: const Color(0xff212121),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 30, 215, 96)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${Duration(milliseconds: nowPlaying["progress_ms"]).inMinutes.remainder(60).toString()}:${Duration(milliseconds: nowPlaying["progress_ms"]).inSeconds.remainder(60).toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            "${Duration(milliseconds: nowPlaying["item"]["duration_ms"]).inMinutes.remainder(60).toString()}:${Duration(milliseconds: nowPlaying["item"]["duration_ms"]).inSeconds.remainder(60).toString()}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous,
                                color: Colors.white, size: 35),
                            onPressed: () {
                              Spotify.previousSong();
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: const Color(0xff121212),
                                  size: 35),
                              onPressed: () {
                                if (isPlaying) {
                                  Spotify.pauseSong();
                                } else {
                                  Spotify.resumeSong();
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next,
                                color: Colors.white, size: 35),
                            onPressed: () {
                              Spotify.nextSong();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      lyrics(),
                      const SizedBox(
                        height: 20,
                      ),
                    ]),
              ),
            ))));
  }

  Widget lyrics() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xff212121),
      ),
      height: 330,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Lyrics",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.transparent, Colors.white],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: lyricsBuilder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget lyricsBuilder() {
    return ListView.builder(
      itemCount: lyricsText.length,
      itemBuilder: (context, index) {
        return SizedBox(
          child: Text(
            lyricsText[index]["words"],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        );
      },
    );
  }
}
