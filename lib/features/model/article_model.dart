class Article {
  final String title;
  final String? image;
  final String? description;
  final String? content;
  final String url;

  Article({
    required this.title,
    this.image,
    this.description,
    this.content,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      image: json['urlToImage'],
      description: json['description'],
      content: json['content'],
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image,
      'description': description,
      'content': content,
      'url': url,
    };
  }
}