import 'package:flutter/material.dart';

class OffersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Elanlar",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1E3A8A)),
      ),
      body: Center(
        child: Text(
          "Elanlar siyahısı buraya gələcək",
          style: TextStyle(fontFamily: 'Roboto'),
        ),
      ),
    );
  }
}
