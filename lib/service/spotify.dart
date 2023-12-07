import 'package:spotify_sdk/spotify_sdk.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Spotify {
  static String clientId = "7b5af824f38d4aa4930218f1784fe2f7";
  static String redirectUrl = "https://apayah.vercel.app";
  static String topArtist = "https://api.spotify.com/v1/me/top/artists";
  static String topSong = "https://api.spotify.com/v1/me/top/tracks";
  static String tokenEndpoint = "https://accounts.spotify.com/api/token";
  static String swapEndpoint = "https://api.spotify.com/v1/swap";
  static String clientSecret = "2fcafad8943f4352a27df8fc1f86237d";
  static String basic =
      "N2I1YWY4MjRmMzhkNGFhNDkzMDIxOGYxNzg0ZmUyZjc6MmZjYWZhZDg5NDNmNDM1MmEyN2RmOGZjMWY4NjIzN2Q=";
  static String recommendedPlaylist =
      "https://api.spotify.com/v1/browse/featured-playlists";
  static String playlistParam = "country=ID&locale=id_ID&timestamp=";
  static Map<dynamic, dynamic> defaultParam = {
    "time_range": "short_term",
    "limit": "10",
    "offset": "0",
  };

  static getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("accessToken");
    var refreshToken = prefs.getString("refreshToken");
    if (refreshToken!.isEmpty) {
      refreshToken = await getRefreshToken();
    }
    Map<dynamic, dynamic> token =
        await http.post(Uri.parse(tokenEndpoint), headers: <String, String>{
      "Authorization": "Basic $basic",
      "Content-Type": "application/x-www-form-urlencoded",
    }, body: <String, String>{
      "grant_type": "refresh_token",
      "refresh_token": accessToken!,
    }).then((value) => jsonDecode(value.body) as Map<dynamic, dynamic>);

    return token["access_token"];
  }

  static checkToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("accessToken") != null) {
      return true;
    } else {
      return false;
    }
  }

  static getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kIsWeb) {
      print("true bang");
    }

    var token = await SpotifySdk.getAccessToken(
      clientId: clientId,
      redirectUrl: redirectUrl,
      scope:
          "app-remote-control, user-read-playback-state, user-modify-playback-state, user-read-currently-playing, user-read-recently-played, user-top-read, user-read-playback-position, user-read-private, user-read-email, user-library-read, user-library-modify, playlist-read-private, playlist-read-collaborative, playlist-modify-public, playlist-modify-private",
    );
    prefs.setString("accessToken", token);

    var refreshToken = await getRefreshToken();
    prefs.setString("refreshToken", refreshToken["refresh_token"]);
    return token;
  }

  static getRecommendedPlaylist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("accessToken");

    // var playlist= await http.get()
  }

  static authorize() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // var token = prefs.getString("accessToken");

    if (kIsWeb) {
      print("true bang");
    }
    await SpotifySdk.connectToSpotifyRemote(
      clientId: "7b5af824f38d4aa4930218f1784fe2f7",
      redirectUrl: "https://apayah.vercel.app",
      // scope:
      //     "app-remote-control, user-read-playback-state, user-modify-playback-state, user-read-currently-playing, user-read-recently-played, user-top-read, user-read-playback-position, user-read-private, user-read-email, user-library-read, user-library-modify, playlist-read-private, playlist-read-collaborative, playlist-modify-public, playlist-modify-private",
      // accessToken: token
    );
  }

  static getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("accessToken");

    var refreshToken = await http.post(Uri.parse(swapEndpoint), headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    }, body: {
      "grant_type": "refresh_token",
      "code": token
    }).then((value) => jsonDecode(value.body) as Map<dynamic, dynamic>);

    return refreshToken;
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

  static playSong(String id) {
    SpotifySdk.play(spotifyUri: "spotify:track:$id");
  }
}