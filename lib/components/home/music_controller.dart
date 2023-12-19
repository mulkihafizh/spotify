import 'package:flutter/material.dart';
import '../../service/spotify.dart';

Widget musicController(
    Map<String, dynamic> nowPlaying, bool isPlaying, double percentage) {
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
