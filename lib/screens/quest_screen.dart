import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'quest_detail_screen.dart';
import '../models/coin_wallet_provider.dart';

class QuestScreen extends StatelessWidget {
  // Statik quest məlumatları (gələcəkdə backend-dən alınacaq)
  final List<Map<String, dynamic>> quests = [
    {
      'id': 1,
      'title': "Quest 1",
      'description': "Bu questi yerinə yetirərək 50 coin qazan",
      'reward': 50,
    },
    {
      'id': 2,
      'title': "Quest 2",
      'description': "Bu questi yerinə yetirərək 100 coin qazan",
      'reward': 100,
    },
    // Daha çox quest əlavə oluna bilər...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Questlər",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1E3A8A)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: quests.length,
          itemBuilder: (context, index) {
            final quest = quests[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: Icon(Icons.task, color: Color(0xFFF97316)),
                title: Text(
                  quest['title'],
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                ),
                subtitle: Text(
                  quest['description'],
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 14),
                ),
                onTap: () async {
                  final reward = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestDetailScreen(quest: quest),
                    ),
                  );
                  if (reward != null) {
                    Provider.of<CoinWalletProvider>(
                      context,
                      listen: false,
                    ).updateBalance(reward);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
