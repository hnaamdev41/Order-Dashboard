import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models.dart';
import 'widgets.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  List<String> selectedFilters = [];
  late AnimationController _headerController;
  late Animation<double> _headerAnimation;
  
  final List<Stock> stocks = [
    Stock(symbol: 'SIGNORIA', price: 0.00),
    Stock(symbol: 'NIFTY BANK', price: 52323.30),
    Stock(symbol: 'NIFTY FIN SERVICE', price: 25255.75),
    Stock(symbol: 'RELCHEMO', price: 162.73),
  ];

  final List<Order> orders = [
    Order(
      time: '08:14:31',
      client: 'AAA001',
      ticker: 'RELIANCE',
      side: 'BUY',
      product: 'CNC',
      executedQty: 50,
      totalQty: 100,
      price: 250.50,
      status: 'Pending',
    ),
    Order(
      time: '08:14:31',
      client: 'AAA003',
      ticker: 'MRF',
      side: 'BUY',
      product: 'NRML',
      executedQty: 10,
      totalQty: 20,
      price: 2700.00,
      status: 'Pending',
    ),
    Order(
      time: '08:14:31',
      client: 'AAA002',
      ticker: 'ASIANPAINT',
      side: 'BUY',
      product: 'NRML',
      executedQty: 10,
      totalQty: 30,
      price: 1500.60,
      status: 'Pending',
    ),
    Order(
      time: '08:14:31',
      client: 'AAA002',
      ticker: 'TATAINVEST',
      side: 'SELL',
      product: 'INTRADAY',
      executedQty: 10,
      totalQty: 10,
      price: 2300.10,
      status: 'Executed',
    ),
  ];

  List<Order> get filteredOrders {
    if (selectedFilters.isEmpty) return orders;
    return orders.where((order) => selectedFilters.contains(order.ticker)).toList();
  }

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _headerAnimation = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Basic Header
            AnimatedBuilder(
              animation: _headerAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _headerAnimation.value),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.bar_chart, color: Colors.white, size: 20),
                        ),
                        Spacer(),
                        Text('MARKETWATCH', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 20),
                        Text('FILES', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 20),
                        Text('PORTFOLIO', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 20),
                        Text('FUNDS', style: TextStyle(fontSize: 14)),
                        Spacer(),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue,
                          child: Text('LK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            // Stock Ticker
            Container(
              height: 80,
              color: Colors.white,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(8),
                itemCount: stocks.length,
                itemBuilder: (context, index) {
                  return AnimatedStockCard(
                    stock: stocks[index],
                    index: index,
                  );
                },
              ),
            ),
            
            // Action Buttons
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.cancel, size: 16),
                    label: Text('Cancel All'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  ),
                  SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.download, size: 16),
                    label: Text('Download'),
                  ),
                  SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.search, size: 16, color: Colors.blue),
                    label: Text('Search', style: TextStyle(color: Colors.blue)),
                    style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            
            // Orders Section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Open Orders', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('${filteredOrders.length} orders', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    // Filter Chips
                    Text('Filter Orders', style: TextStyle(fontWeight: FontWeight.w500)),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['RELIANCE', 'ASIANPAINT', 'MRF'].map((filter) {
                        return FilterChip(
                          label: Text(filter),
                          selected: selectedFilters.contains(filter),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedFilters.add(filter);
                              } else {
                                selectedFilters.remove(filter);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Orders List
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          return AnimatedOrderCard(
                            order: filteredOrders[index],
                            index: index,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
