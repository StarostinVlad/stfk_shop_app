class Data {
  String title;
  String image;
  String href;

  Data({this.title, this.image, this.href});

  @override
  String toString() {
    return '{ title: $title, image: $image, href: $href}';
  }
  static const String DOMAIN = 'https://skladtfk.ru';
}
