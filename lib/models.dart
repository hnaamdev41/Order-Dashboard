class Stock {
  final String symbol;
  final double price;

  Stock({required this.symbol, required this.price});
}

class Order {
  final String time;
  final String client;
  final String ticker;
  final String side;
  final String product;
  final int executedQty;
  final int totalQty;
  final double price;
  final String status;

  Order({
    required this.time,
    required this.client,
    required this.ticker,
    required this.side,
    required this.product,
    required this.executedQty,
    required this.totalQty,
    required this.price,
    required this.status,
  });
}
