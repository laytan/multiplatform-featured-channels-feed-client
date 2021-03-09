class Video {
  final String url;
  final String publishedAt;
  final String thumbnailURL;
  final String title;
  final String views;
  final String channelTitle;

  String get fullURL => 'https://youtube.com' + url;

  Video(this.url, this.publishedAt, this.thumbnailURL, this.title, this.views,
      this.channelTitle);

  factory Video.fromJSON(Map<String, dynamic> json) => Video(
        json['url'] ?? '',
        json['publishedAt'] ?? '',
        json['thumbnail'] ?? '',
        json['title'] ?? '',
        json['views'] ?? '',
        json['channelTitle'] ?? '',
      );
}
