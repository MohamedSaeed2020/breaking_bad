class Quote {
  late String quote;

  //named constructor to map json
  Quote.fromJson(Map<String, dynamic> json) {
    quote = json['quote'];
  }
}
