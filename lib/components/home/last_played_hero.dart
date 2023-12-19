import 'package:flutter/material.dart';

Widget lastPlayedHeroBuilder(List<dynamic> lastPlayed) {
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
