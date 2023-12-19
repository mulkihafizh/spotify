import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../service/spotify.dart';
import '../../components/search/top_result.dart';
import '../../components/search/song_result.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearching = false;
  Map<String, dynamic> artist = {};
  List<dynamic> tracks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff121212),
        body: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 130,
                  padding: const EdgeInsets.only(
                      top: 50, left: 20, right: 20, bottom: 20),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    onChanged: (value) async {
                      if (mounted) {
                        if (value.length > 3) {
                          setState(() {
                            isSearching = true;
                          });
                          Spotify.search(value).then((val) {
                            List<dynamic> topArtist =
                                val['artists']['items'] as List<dynamic>;

                            List<dynamic> songList =
                                val['tracks']['items'] as List<dynamic>;

                            setState(() {
                              artist = topArtist[0];
                              tracks = songList;
                            });
                          });
                        } else {
                          setState(() {
                            isSearching = false;
                            artist = {};
                          });
                        }
                      }
                    },
                  ),
                ),
                if (isSearching)
                  if (isSearching && artist.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Top Result",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          topOneSearch(artist),
                          const SizedBox(height: 20),
                          const Text(
                            "Songs",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          trackList(tracks)
                        ],
                      ),
                    )
                  else
                    Container(
                        height: MediaQuery.of(context).size.height - 200,
                        alignment: Alignment.center,
                        child: LoadingAnimationWidget.waveDots(
                            color: Colors.white, size: 30))
                else
                  Container(
                    height: MediaQuery.of(context).size.height - 200,
                    alignment: Alignment.center,
                    child: const Text(
                      "Search for your favorite artist",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ]),
        ));
  }
}
