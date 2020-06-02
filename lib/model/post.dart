class Post {
  String imageUrl;
  String title;
  int like;

  Post({
    this.imageUrl,
    this.like,
    this.title,
  });

  String url() {
    return imageUrl;
  }
}
