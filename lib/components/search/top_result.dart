import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget topOneSearch(artist) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
        color: const Color(0xff212121),
        borderRadius: BorderRadius.circular(10)),
    width: double.infinity,
    child: Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            image: DecorationImage(
              image: NetworkImage(artist['images'][0]['url'] as String),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          artist['name'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          artist['genres'][0],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${NumberFormat('#,###').format(artist['followers']['total'])} Followers",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "•",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 30,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 30, 215, 96)),
                ),
                onPressed: null,
                child: const Text(
                  "+ Follow",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
