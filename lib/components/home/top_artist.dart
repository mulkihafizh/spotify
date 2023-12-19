import 'package:flutter/material.dart';
import '../../service/spotify.dart';

Widget artistsBuilder(List<dynamic> topArtist) {
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
            Spotify.playSong(topArtist[index]["uri"].toString());
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

Widget topArtists(List<dynamic> topArtist) {
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
        child: artistsBuilder(topArtist),
      ),
    ),
  );
}
