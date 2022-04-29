class Sentiment {
  final double neutral;
  final double positive;
  final double negative;
  final double compound;

  Sentiment.fromJson(Map<String, dynamic> json)
      : neutral = json['neu'] ?? 0,
        negative = json['neg'] ?? 0,
        positive = json['pos'] ?? 0,
        compound = json['compound'] ?? 0;
}
