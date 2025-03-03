class Article {
  String id;
  String title;
  String author;
  int views;
  DateTime date;
  String category;
  String content;

  Article({
    required this.id,
    required this.title,
    required this.author,
    required this.views,
    required this.date,
    required this.category,
    required this.content,
  });

  void incrementViews() {
    views++;
  }
}