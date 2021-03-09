import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multiplatform/featured_channel.dart';
import 'package:http/http.dart' as http;
import 'package:multiplatform/video.dart';

class FeaturedChannelsState extends ChangeNotifier {
  late final Uri _apiUrl;

  List<FeaturedChannel> _featuredChannels = [];
  List<FeaturedChannel> get featuredChannels => _featuredChannels;
  List<Video> get videos {
    List<Video> videos = [];
    _featuredChannels.forEach((channel) {
      videos.addAll(channel.latestVideos);
    });
    return videos;
  }

  bool get hasChannels => _featuredChannels.isNotEmpty;

  bool _loading = false;
  bool get isLoading => _loading;

  String _error = '';
  String get error => _error;
  bool get hasError => _error.isNotEmpty;

  FeaturedChannelsState(String apiUrl) {
    _apiUrl = Uri.parse(apiUrl);
  }

  Future<void> fetchForChannel(String channel) async {
    _loading = true;
    notifyListeners();

    try {
      final urlWithChannel = _apiUrl.replace(query: 'channel=' + channel);
      Map<String, dynamic> res =
          jsonDecode((await http.get(urlWithChannel)).body);

      if ((res['error'] as String? ?? '').isNotEmpty) {
        _error = res['error'];
      } else {
        _featuredChannels = (res['channels'] as List)
            .map((channelJSON) => FeaturedChannel.fromJSON(channelJSON))
            .toList();
      }
    } on SocketException {
      _error = 'No Internet connection detected';
    } catch (e) {
      print(e);
      _error =
          'Something went wrong retrieving channels, please try again later';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
