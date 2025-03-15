import 'package:flutter/material.dart';

class OfferDetailScreen extends StatelessWidget {
  final Map<String, dynamic> offer;

  // Elanı göstərmək üçün, offer məlumatlarını parametr kimi alırıq
  OfferDetailScreen({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Elan Detalları",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              offer['title'] ?? "Başlıq yoxdur",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            SizedBox(height: 10),
            Text(
              offer['description'] ?? "Təsvir yoxdur",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: Color(0xFF333333),
              ),
            ),
            // Gələcəkdə əlavə məlumatlar və ya interaktiv elementlər buraya əlavə edilə bilər.
          ],
        ),
      ),
    );
  }
}
