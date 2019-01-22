class Offer {
  final int id;
  final String title;
  final String description;
  final double price;

  // TODO: add expiration date.

  Offer({this.id, this.title, this.description, this.price});

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
    );
  }
}
