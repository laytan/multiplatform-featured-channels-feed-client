import 'package:multiplatform/video.dart';

class FeaturedChannel {
  final String subscriberCount;
  final String urlTitle;
  final String displayTitle;
  final List<Video> latestVideos;

  FeaturedChannel(this.subscriberCount, this.urlTitle, this.displayTitle,
      this.latestVideos);

  factory FeaturedChannel.fromJSON(Map<String, dynamic> json) =>
      FeaturedChannel(
          json['subscriberCount'] ?? '',
          json['urlTitle'] ?? '',
          json['displayTitle'] ?? '',
          (json['latestVideos'] as List).map((videoJSON) {
            videoJSON['channelTitle'] = json['displayTitle'];
            return Video.fromJSON(videoJSON);
          }).toList());
}
