import 'package:flutter/material.dart';
import 'package:scotiabank_app/widgets/bottom_navbar.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart'; // For charts
import 'package:scotiabank_app/screens/profile_screen.dart';
import 'package:scotiabank_app/screens/settings_screen.dart';
import 'package:scotiabank_app/screens/more_screen.dart';
import 'package:scotiabank_app/screens/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final bool isDefaultUser;

  HomeScreen({required this.userName, required this.isDefaultUser});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  List banking = [];
  List creditCards = [];
  List investments = [];
  List transactions = [];
  bool _isLoading = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    if (widget.isDefaultUser) {
      _loadSampleData();
    } else {
      _loadInitialData();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Dio dio = Dio();
      Response savingsResponse = await dio.get('https://nawazchowdhury.com/sav.php');
      Response checkingResponse = await dio.get('https://nawazchowdhury.com/chq.php');

      if (savingsResponse.statusCode == 200 && checkingResponse.statusCode == 200) {
        setState(() {
          banking = [
            {
              "title": "Savings Account",
              "balance": "\$${savingsResponse.data['balance']}",
              "accountNumber": savingsResponse.data['accountNumber']
            },
            {
              "title": "Checking Account",
              "balance": "\$${checkingResponse.data['balance']}",
              "accountNumber": checkingResponse.data['accountNumber']
            }
          ];
          _isLoading = false;
        });
      } else {
        _loadSampleData();
      }
    } catch (e) {
      print("Error: $e");
      _loadSampleData();
    }
  }

  void _loadSampleData() {
    setState(() {
      banking = [
        {"title": "Savings Account", "balance": "\$1,000.00", "accountNumber": "1234"},
        {"title": "Checking Account", "balance": "\$500.00", "accountNumber": "5678"},
      ];
      creditCards = [
        {"title": "Scene+ Visa card", "balance": "-\$27.98", "accountNumber": "5019"},
      ];
      investments = [
        {"title": "Non-Reg Savings - BNS", "balance": "\$0.00", "accountNumber": "0895"},
      ];
      transactions = [
        {"date": "Aug 10, 2024", "description": "Grocery Store", "amount": "-\$50.00"},
        {"date": "Aug 9, 2024", "description": "Salary Deposit", "amount": "\$2,000.00"},
      ];
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _buildHomeContent(),  // Main home content
      ProfileScreen(),      // Profile screen
      SettingsScreen(),     // Settings screen
      MoreScreen(),         // More screen
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          _getTitle(),
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()), // Navigate to NotificationScreen
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              setState(() {
                _currentIndex = 2; // Switch to settings screen
              });
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 1:
        return 'Profile';
      case 2:
        return 'Settings';
      case 3:
        return 'More';
      default:
        return '${_getGreeting()}, ${widget.userName}';
    }
  }

  Widget _buildHomeContent() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
      child: FadeTransition(
        opacity: _animation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverviewSection(),
              SizedBox(height: 16),
              _buildQuickActionsSection(),
              SizedBox(height: 16),
              _buildAccountSection(),
              SizedBox(height: 16),
              _buildTransactionButtons(), // Transaction buttons
              SizedBox(height: 16),
              _buildCreditCardSection(),
              SizedBox(height: 16),
              _buildInvestmentSection(),
              SizedBox(height: 16),
              _buildTransactionHistorySection(),
              SizedBox(height: 16),
              _buildSpendingAnalysisSection(),
              SizedBox(height: 16),
              _buildFinancialInsightsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _showTransactionsDialog('Chequing Transactions', [
                {"date": "Aug 10, 2024", "description": "Grocery Store", "amount": "-\$50.00"},
                {"date": "Aug 7, 2024", "description": "Gas Station", "amount": "-\$30.00"},
                {"date": "Aug 5, 2024", "description": "Dinner", "amount": "-\$70.00"}
              ]);
            },
            child: Text('View Chequing Transactions'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.deepPurpleAccent, padding: EdgeInsets.symmetric(vertical: 15),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
              shadowColor: Colors.black45,
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _showTransactionsDialog('Savings Transactions', [
                {"date": "Aug 9, 2024", "description": "Salary Deposit", "amount": "\$2,000.00"},
                {"date": "Aug 1, 2024", "description": "Transfer to Chequing", "amount": "-\$500.00"}
              ]);
            },
            child: Text('View Saving Transactions'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.tealAccent, padding: EdgeInsets.symmetric(vertical: 15),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
              shadowColor: Colors.black45,
            ),
          ),
        ),
      ],
    );
  }

  void _showTransactionsDialog(String title, List<Map<String, String>> transactions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, int index) {
                var transaction = transactions[index];
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction['description'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(transaction['date'] ?? '', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 4),
                      Text(transaction['amount'] ?? '', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      Divider(),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOverviewSection() {
    double totalBalance = 0.0;
    for (var account in banking) {
      totalBalance += double.parse(account["balance"].replaceAll(RegExp(r'[^0-9.]'), ''));
    }
    for (var card in creditCards) {
      totalBalance += double.parse(card["balance"].replaceAll(RegExp(r'[^0-9.]'), ''));
    }
    for (var investment in investments) {
      totalBalance += double.parse(investment["balance"].replaceAll(RegExp(r'[^0-9.]'), ''));
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Total Balance', style: TextStyle(fontSize: 16)),
            Text('\$${totalBalance.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.pinkAccent, Colors.deepOrangeAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickActionItem(Icons.send, 'Transfer Money', Colors.redAccent),
                _buildQuickActionItem(Icons.payment, 'Pay Bills', Colors.green),
                _buildQuickActionItem(Icons.account_balance_wallet, 'Add Funds', Colors.blue),
                _buildQuickActionItem(Icons.credit_card, 'View Cards', Colors.orange),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickActionItem(Icons.attach_money, 'Withdraw Cash', Colors.purple),
                _buildQuickActionItem(Icons.file_copy, 'View Statements', Colors.brown),
                _buildQuickActionItem(Icons.qr_code_scanner, 'Scan & Pay', Colors.pink),
                _buildQuickActionItem(Icons.more_horiz, 'More', Colors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 6,
            onPressed: () {
              // Implement quick action functionality
            },
            child: Icon(icon, color: Colors.white),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.white)),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Banking (${banking.length}/2)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            ...banking.map<Widget>((account) {
              return _buildAccountDetail(account["title"], account["balance"], account["accountNumber"]);
            }).toList(),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Implement Open Account functionality
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.add_circle_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Open account', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardSection() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Credit cards (${creditCards.length})', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            ...creditCards.map<Widget>((card) {
              return _buildAccountDetail(card["title"], card["balance"], card["accountNumber"]);
            }).toList(),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Implement Add Card functionality
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.add_circle_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Add card', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestmentSection() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Investments (${investments.length})', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            ...investments.map<Widget>((investment) {
              return _buildAccountDetail(investment["title"], investment["balance"], investment["accountNumber"]);
            }).toList(),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Implement Add Investment functionality
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.add_circle_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Add investment', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHistorySection() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transaction History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            ...transactions.map<Widget>((transaction) {
              return ListTile(
                title: Text(transaction["description"], style: TextStyle(fontSize: 16)),
                subtitle: Text(transaction["date"], style: TextStyle(color: Colors.grey)),
                trailing: Text(transaction["amount"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingAnalysisSection() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.orange[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Spending Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 1.5,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.red,
                      value: 40,
                      title: 'Groceries',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      color: Colors.blue,
                      value: 30,
                      title: 'Entertainment',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      color: Colors.green,
                      value: 20,
                      title: 'Utilities',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      color: Colors.yellow,
                      value: 10,
                      title: 'Others',
                      radius: 50,
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

  Widget _buildFinancialInsightsSection() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.green[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Financial Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 1.3,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 20,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return 'Jan';
                          case 1:
                            return 'Feb';
                          case 2:
                            return 'Mar';
                          case 3:
                            return 'Apr';
                          case 4:
                            return 'May';
                          case 5:
                            return 'Jun';
                          default:
                            return '';
                        }
                      },
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTitles: (double value) {
                        if (value % 5 == 0) {
                          return '\$${value.toInt()}k';
                        }
                        return '';
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [BarChartRodData(y: 8, colors: [Colors.red])],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [BarChartRodData(y: 10, colors: [Colors.orange])],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [BarChartRodData(y: 14, colors: [Colors.yellow])],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [BarChartRodData(y: 15, colors: [Colors.green])],
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [BarChartRodData(y: 13, colors: [Colors.blue])],
                    ),
                    BarChartGroupData(
                      x: 5,
                      barRods: [BarChartRodData(y: 10, colors: [Colors.purple])],
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

  Widget _buildAccountDetail(String title, String balance, String accountNumber) {
    return GestureDetector(
      onTap: () {
        // Implement onTap functionality for account detail
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('Account ending in $accountNumber', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 5),
          Text(balance, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
