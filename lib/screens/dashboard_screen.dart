import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'offers_screen.dart';
import 'profile_screen.dart';
import 'add_offer_screen.dart';
import 'offer_detail_screen.dart';
import 'qr_scan_screen.dart';
import 'quest_screen.dart';
import 'partner_quest_screen.dart';
import '../services/api_service.dart';
import '../models/coin_wallet_provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  late PageController _pageController;
  late Future<List<dynamic>> _offersFuture;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _loadOffers();
  }

  void _loadOffers() {
    _offersFuture = ApiService.fetchOffers();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Dashboard (Ana Səhifə) məzmunu: coin balansı və elanlar siyahısı
  Widget _dashboardContent(BuildContext context) {
    final coinWallet = Provider.of<CoinWalletProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Coin Balansı Kartı
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: Color(0xFF1E3A8A)),
                  SizedBox(width: 10),
                  Text(
                    "Coin Balansı: ${coinWallet.balance}",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          // Aktiv Elanlar Başlığı
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Aktiv Elanlar",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
          ),
          SizedBox(height: 10),
          // Elanlar Siyahısı
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _offersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Xəta: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("Heç bir elan tapılmadı"));
                } else {
                  final offers = snapshot.data!;
                  return ListView.builder(
                    itemCount: offers.length,
                    itemBuilder: (context, index) {
                      final offer = offers[index];
                      return ListTile(
                        leading: Icon(Icons.work, color: Color(0xFFF97316)),
                        title: Text(
                          offer['title'],
                          style: TextStyle(fontFamily: 'Roboto'),
                        ),
                        subtitle: Text(
                          offer['description'],
                          style: TextStyle(fontFamily: 'Roboto', fontSize: 14),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => OfferDetailScreen(offer: offer),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Səhifələr siyahısı
  List<Widget> _pages(BuildContext context) {
    return [
      _dashboardContent(context),
      OffersScreen(),
      ProfileScreen(),
      QuestScreen(),
      PartnerQuestScreen(),
    ];
  }

  List<String> _titles = [
    "Dashboard",
    "Elanlar",
    "Profil",
    "Questlər",
    "Partnyor",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Color(0xFF1E3A8A)),
      ),
      // GestureDetector istifadə edərək horizontal drag update ilə səhifə keçidini təmin edirik
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! < -10) {
            // Sağ sürüş: növbəti səhifə (delta mənfi olduqda)
            if (_currentIndex < _pages(context).length - 1) {
              setState(() {
                _currentIndex++;
              });
              _pageController.animateToPage(
                _currentIndex,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          } else if (details.primaryDelta! > 10) {
            // Sol sürüş: əvvəlki səhifə
            if (_currentIndex > 0) {
              setState(() {
                _currentIndex--;
              });
              _pageController.animateToPage(
                _currentIndex,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          }
        },
        child: PageView(
          controller: _pageController,
          physics:
              NeverScrollableScrollPhysics(), // Default swipe deaktiv edirik
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: _pages(context),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF1E3A8A),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Səhifə"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Elanlar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Questlər"),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: "Partnyor",
          ),
        ],
      ),
      floatingActionButton:
          _currentIndex == 0
              ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    backgroundColor: Color(0xFFF97316),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddOfferScreen(),
                        ),
                      );
                      if (result == true) {
                        setState(() {
                          _loadOffers();
                        });
                      }
                    },
                    child: Icon(Icons.add),
                  ),
                  SizedBox(height: 10),
                  FloatingActionButton(
                    backgroundColor: Color(0xFF1E3A8A),
                    onPressed: () async {
                      final qrResult = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QRScanScreen()),
                      );
                      if (qrResult != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("QR Kod: $qrResult")),
                        );
                      }
                    },
                    child: Icon(Icons.qr_code_scanner),
                  ),
                ],
              )
              : null,
    );
  }
}
