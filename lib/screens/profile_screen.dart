import 'package:flutter/material.dart';
import 'profile_edit_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Nümunə profil məlumatları, gələcəkdə backend-dən və ya Provider-dən alınacaq
    final profile = {
      'firstName': 'Əli',
      'lastName': 'Məmmədov',
      'email': 'ali@example.com',
      'phone': '+994501234567',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil",
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Mərkəzə hizalama
          children: [
            // Profil şəkli (placeholder)
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFF1E3A8A),
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Ad: ${profile['firstName']}",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Soyad: ${profile['lastName']}",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Email: ${profile['email']}",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Telefon: ${profile['phone']}",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 18),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileEditScreen(userId: "user1"),
                    ),
                  );
                  if (result == true) {
                    // Profili yenidən yükləmə məntiqi buraya əlavə edilə bilər
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E3A8A),
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Profilinizi Redaktə Edin",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
