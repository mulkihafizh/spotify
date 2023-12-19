import 'package:flutter/material.dart';
import '../../service/spotify.dart';

Widget trackBuilder(tracks) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: tracks.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Spotify.playSong(tracks[index]["uri"].toString());
          },
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(tracks[index]["album"]["images"][0]
                              ["url"]
                          .toString()),
                      fit: BoxFit.cover,
                    ),
                    color: const Color(0xff212121)),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tracks[index]["name"].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      tracks[index]["artists"][0]["name"].toString(),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 170, 170, 170),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget trackList(tracks) {
  return SizedBox(
    child: trackBuilder(tracks),
  );
}
