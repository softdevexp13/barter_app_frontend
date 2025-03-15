import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddOfferScreen extends StatefulWidget {
  @override
  _AddOfferScreenState createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController =
      TextEditingController(); // Yeni sahə

  // Geniş xidmət kateqoriyaları siyahısı – əmək tələb edən işlərin müxtəlif sahələri
  final List<String> _categories = [
    'Ümumi Ustalıq',
    'Bərbərlik və Saç Düzümü',
    'Diş Həkimliyi',
    'Santexnika',
    'Elektrik Xidmətləri',
    'Təmizlik Xidmətləri',
    'Tikinti və Təmir',
    'Boya və Dekorasiya',
    'Bağ və Peyzaj Baxımı',
    'Avtomobil Təmiri',
    'Metal Emalı və Qaynaq',
    'Daş və Beton İşləri',
    'Pəncərə və Qapı Təmiri',
    'Divar və Döşəmə Quraşdırılması',
    'Çatdırılma Xidmətləri',
    'Kiçik Ustalıq İşləri',
    'Qrafik və Dizayn Xidmətləri',
    'Digər',
  ];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // İlkin olaraq siyahının ilk elementini seçirik
    _selectedCategory = _categories[0];
  }

  Future<void> _submitOffer() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('http://localhost:3000/api/offers');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": _titleController.text,
          "description": _descriptionController.text,
          "category": _selectedCategory,
          "price":
              int.tryParse(_priceController.text) ?? 0, // Yeni coin qiyməti
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data['message'])));
        // Uğurlu elan əlavə edildikdən sonra true nəticəsi ilə geri qayıt
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Elan əlavə edilmədi, zəhmət olmasa yenidən cəhd edin.",
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Yeni Elan Əlavə Et",
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Elan Başlığı üçün input sahəsi
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Elan Başlığı",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "Başlıq daxil edin"
                              : null,
                ),
                SizedBox(height: 20),
                // Elan Təsviri üçün input sahəsi
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Elan Təsviri",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 4,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "Təsviri daxil edin"
                              : null,
                ),
                SizedBox(height: 20),
                // Kateqoriya seçimi üçün dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kateqoriya",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  value: _selectedCategory,
                  items:
                      _categories
                          .map(
                            (cat) => DropdownMenuItem<String>(
                              value: cat,
                              child: Text(cat),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                // Xidmət Qiyməti (coin) üçün input sahəsi
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: "Xidmət Qiyməti (coin)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Qiyməti daxil edin";
                    }
                    if (int.tryParse(value) == null) {
                      return "Yalnız rəqəm daxil edin";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Elanı Yerləşdir düyməsi
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1E3A8A),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _submitOffer,
                  child: Text(
                    "Elanı Yerləşdir",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Gələcəkdə əlavə olunan elanlərin siyahısı da burada göstərilə bilər.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
