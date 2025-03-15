import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileEditScreen extends StatefulWidget {
  final String userId; // İstifadəçi ID-si (məsələn, "user1")

  ProfileEditScreen({required this.userId});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Kontrollerlər
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;

  // Backend-dən mövcud profil məlumatlarını yükləyirik
  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
      'http://localhost:3000/api/profile?userId=${widget.userId}',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final profile = data['profile'];
      setState(() {
        _firstNameController.text = profile['firstName'] ?? "";
        _lastNameController.text = profile['lastName'] ?? "";
        _emailController.text = profile['email'] ?? "";
        _phoneController.text = profile['phone'] ?? "";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profil yüklənərkən xəta baş verdi")),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Profil yeniləmə funksiyası
  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final url = Uri.parse('http://localhost:3000/api/profile/update');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": widget.userId,
          "firstName": _firstNameController.text,
          "lastName": _lastNameController.text,
          "email": _emailController.text,
          "phone": _phoneController.text,
        }),
      );
      setState(() {
        _isLoading = false;
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data['message'])));
        Navigator.pop(context, true); // Uğurlu yeniləmə nəticəsi
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Profil yenilənmədi, zəhmət olmasa yenidən cəhd edin.",
            ),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil Redaktəsi",
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
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Profil Şəkili (placeholder olaraq CircleAvatar)
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFF1E3A8A),
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Ad (mərkəzləşdirilmiş)
                        TextFormField(
                          controller: _firstNameController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            label: Center(
                              child: Text(
                                "Ad",
                                style: TextStyle(fontFamily: 'Montserrat'),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? "Ad daxil edin"
                                      : null,
                        ),
                        SizedBox(height: 20),
                        // Soyad (mərkəzləşdirilmiş)
                        TextFormField(
                          controller: _lastNameController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            label: Center(
                              child: Text(
                                "Soyad",
                                style: TextStyle(fontFamily: 'Montserrat'),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? "Soyad daxil edin"
                                      : null,
                        ),
                        SizedBox(height: 20),
                        // Email (mərkəzləşdirilmiş)
                        TextFormField(
                          controller: _emailController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            label: Center(
                              child: Text(
                                "Email",
                                style: TextStyle(fontFamily: 'Montserrat'),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email daxil edin";
                            }
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                              return "Düzgün email daxil edin";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        // Telefon (mərkəzləşdirilmiş)
                        TextFormField(
                          controller: _phoneController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            label: Center(
                              child: Text(
                                "Telefon",
                                style: TextStyle(fontFamily: 'Montserrat'),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? "Telefon daxil edin"
                                      : null,
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1E3A8A),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _updateProfile,
                          child: Text(
                            "Yenilə",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
