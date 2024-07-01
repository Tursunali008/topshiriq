class Product {
  String id;
  final String title;
  final String imageUrl;
  final double price;
  final int amount;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.amount,
    this.isFavorite = false,
  });

  @override
  String toString() {
    // TODO: implement toString
    return """
Mahsulot #$id
Nomi: $title
Narxi: $price
Miqdori: $amount
Sevimli: $isFavorite
Rasmi: $imageUrl
""";
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String? ?? "",
      title: json['title']as String? ?? "",
      imageUrl: json['imageUrl']as String? ?? "",
      price: json['price'] as double? ?? 0.0,
      amount: json['amount']as int ,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
      'amount': amount,
      'isFavorite': isFavorite,
    };
  }
}
