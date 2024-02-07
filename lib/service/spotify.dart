import 'package:spotify_sdk/spotify_sdk.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Spotify {
  static String clientId = dotenv.env["CLIENT_ID"]!;
  static String clientSecret = dotenv.env["CLIENT_SECRET"]!;
  static String redirectUrl = "https://apayah.vercel.app";
  static String topArtist = "https://api.spotify.com/v1/me/top/artists";
  static String topSong = "https://api.spotify.com/v1/me/top/tracks";
  static String tokenEndpoint = "https://accounts.spotify.com/api/token";
  static String swapEndpoint = "https://api.spotify.com/v1/swap";
  static String recommendedPlaylist =
      "https://api.spotify.com/v1/browse/featured-playlists";
  static String playlistParam = "country=ID&locale=id_ID&timestamp=";
  static Map<dynamic, dynamic> defaultParam = {
    "time_range": "short_term",
    "limit": "10",
    "offset": "0",
  };
  static String lyricsEndpoint =
      "https://spotify-lyric-api-984e7b4face0.herokuapp.com/";

  static getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = await SpotifySdk.getAccessToken(
      clientId: clientId,
      redirectUrl: redirectUrl,
      scope:
          "app-remote-control, user-read-playback-state, user-modify-playback-state, user-read-currently-playing, user-read-recently-played, user-top-read, user-read-playback-position, user-read-private, user-read-email, user-library-read, user-library-modify, playlist-read-private, playlist-read-collaborative, playlist-modify-public, playlist-modify-private",
    );
    prefs.setString("accessToken", token);

    return token;
  }

  static getRecommendedPlaylist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("accessToken");
    var playlist = await http.get(
        Uri.parse(
            "$recommendedPlaylist?$playlistParam${DateTime.now().toString().replaceAll(" ", "T")}"),
        headers: {
          "Authorization": "Bearer $token"
        }).then((value) => jsonDecode(value.body) as Map<dynamic, dynamic>);

    return playlist['playlists']['items'];
  }

  static checkValidity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("accessToken") != null) {
      var validity = await http
          .get(Uri.parse("https://api.spotify.com/v1/me/player/devices"),
              headers: {
                "Authorization": "Bearer ${prefs.getString("accessToken")}"
              })
          .then((value) => value.statusCode)
          .onError((error, stackTrace) => 401);
      if (validity == 401) {
        prefs.clear();
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  static authorize() async {
    if (kIsWeb) {
      await SpotifySdk.connectToSpotifyRemote(
        clientId: "7b5af824f38d4aa4930218f1784fe2f7",
        redirectUrl: "https://apayah.vercel.app",
      );
      return;
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("accessToken");
      await SpotifySdk.connectToSpotifyRemote(
          clientId: "7b5af824f38d4aa4930218f1784fe2f7",
          redirectUrl: "https://apayah.vercel.app",
          scope:
              "app-remote-control, user-read-playback-state, user-modify-playback-state, user-read-currently-playing, user-read-recently-played, user-top-read, user-read-playback-position, user-read-private, user-read-email, user-library-read, user-library-modify, playlist-read-private, playlist-read-collaborative, playlist-modify-public, playlist-modify-private",
          accessToken: token);
    }
  }

  static getTopArtist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString("accessToken");
    Map<String, dynamic> artists = await http.get(
        Uri.parse("$topArtist?time_range=short_term&limit=10&offset=0"),
        headers: {
          "Authorization": "Bearer $token"
        }).then((value) => jsonDecode(value.body) as Map<String, dynamic>);

    return artists["items"];
  }

  static getLastPlayed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("accessToken");
    String unixTime = DateTime.now().millisecondsSinceEpoch.toString();

    var lastPlayed = await http.get(
        Uri.parse(
            "https://api.spotify.com/v1/me/player/recently-played?before=$unixTime&limit=8"),
        headers: {
          "Authorization": "Bearer $token"
        }).then((value) => jsonDecode(value.body) as Map<String, dynamic>);
    return lastPlayed["items"];
  }

  static getTopSong() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("accessToken");
    var song = await http.get(
        Uri.parse("$topSong?time_range=short_term&limit=10&offset=0"),
        headers: {
          "Authorization": "Bearer $token"
        }).then((value) => jsonDecode(value.body) as Map<String, dynamic>);
    return song["items"];
  }

  static me() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("accessToken");
    var me = await http.get(Uri.parse("https://api.spotify.com/v1/me"),
        headers: {
          "Authorization": "Bearer $token"
        }).then((value) => jsonDecode(value.body) as Map<String, dynamic>);
    return me;
  }

  static nowPlaying() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("accessToken");
    var status = await http.get(
        Uri.parse("https://api.spotify.com/v1/me/player/currently-playing"),
        headers: {
          "Authorization": "Bearer $token"
        }).then((value) => jsonDecode(value.body) as Map<String, dynamic>);

    return status;
  }

  static search(String query) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("accessToken");
    Map<String, dynamic> search = await http.get(
        Uri.parse(
            "https://api.spotify.com/v1/search?q=$query&type=artist%2Ctrack&limit=10"),
        headers: {
          "Authorization": "Bearer $token"
        }).then((value) => jsonDecode(value.body) as Map<String, dynamic>);
    return search;
  }

  static getLyrics(String id) async {
    var lyrics = await http
        .get(Uri.parse("$lyricsEndpoint?trackid=$id"))
        .then((value) => jsonDecode(value.body) as Map<String, dynamic>);

    return lyrics["lines"];
  }

  static playSong(String id) {
    SpotifySdk.play(
      spotifyUri: id,
    );
  }

  static pauseSong() {
    SpotifySdk.pause();
  }

  static resumeSong() {
    SpotifySdk.resume();
  }

  static nextSong() {
    SpotifySdk.skipNext();
  }

  static previousSong() {
    SpotifySdk.skipPrevious();
  }
}
