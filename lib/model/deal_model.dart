// title, description, price, value, discount_amount, url, image_url
class Deal {
  final String title;
  final String description;
  final double price;
  final double value;
  final double discountAmount;
  final String url;
  final String imageUrl;
  final String expiresAt;

  Deal.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? '',
        description = json['description'] ?? '',
        price = json['price'] ?? 0,
        value = json['value'] ?? 0,
        discountAmount = json['discount_amount'] ?? 0,
        url = json['url'] ?? '',
        imageUrl = json['image_url'] ?? '',
        expiresAt = json['expires_at'] ?? '';
}
