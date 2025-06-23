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
            // FIXED: Responsive Header
            AnimatedBuilder(
              animation: _headerAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _headerAnimation.value),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.bar_chart, color: Colors.white, size: 18),
                        ),
                        SizedBox(width: 12),
                        
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(child: _navItem('MARKETWATCH')),
                              SizedBox(width: 12),
                              Flexible(child: _navItem('FILES')),
                              SizedBox(width: 12),
                              Flexible(child: _navItem('PORTFOLIO')),
                              SizedBox(width: 12),
                              Flexible(child: _navItem('FUNDS')),
                            ],
                          ),
                        ),
                        
                        SizedBox(width: 12),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue,
                          child: Text(
                            'LK', 
                            style: TextStyle(
                              color: Colors.white, 
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
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
            
            // FIXED: Better Action Buttons Layout
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildBigActionButton(
                          onPressed: () => _showCancelAllDialog(),
                          icon: Icons.cancel,
                          label: 'Cancel All',
                          color: Colors.red,
                          filled: true,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildBigActionButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Download coming soon')),
                            );
                          },
                          icon: Icons.download,
                          label: 'Download',
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: _buildBigActionButton(
                      onPressed: () => _showSearchDialog(),
                      icon: Icons.search,
                      label: 'Search',
                      color: Colors.blue,
                    ),
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
                        Text(
                          'Open Orders',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text('${filteredOrders.length} orders', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 16),
                    
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

  Widget _navItem(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBigActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    bool filled = false,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: filled
              ? ElevatedButton.icon(
                  onPressed: onPressed,
                  icon: Icon(icon, size: 18),
                  label: Text(
                    label, 
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              : OutlinedButton.icon(
                  onPressed: onPressed,
                  icon: Icon(icon, size: 18, color: color),
                  label: Text(
                    label, 
                    style: TextStyle(
                      color: color, 
                      fontSize: 15, 
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: color, width: 1.5),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
        );
      },
    );
  }

  void _showCancelAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel All Orders'),
        content: Text('Are you sure you want to cancel all pending orders?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All orders cancelled successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Cancel All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Orders'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter stock symbol (e.g., RELIANCE)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Search feature coming soon')),
              );
            },
            child: Text('Search'),
          ),
        ],
      ),
    );
  }
}
