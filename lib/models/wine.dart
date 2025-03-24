class Wine {
  int wineNumber;
  String name;
  String color;
  String smell;
  String taste;
  String aftertaste;
  String comments;
  double acidity;
  double body;
  double fruit;
  double sweetness;
  double tannins;
  double rating;

  Wine({
    required this.wineNumber,
    this.name = '',
    this.color = '',
    this.smell = '',
    this.taste = '',
    this.aftertaste = '',
    this.comments = '',
    this.acidity = 0.0,
    this.body = 0.0,
    this.fruit = 0.0,
    this.sweetness = 0.0,
    this.tannins = 0.0,
    this.rating = 3.0,
  });
}
