import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PartnerQuestScreen extends StatefulWidget {
  @override
  _PartnerQuestScreenState createState() => _PartnerQuestScreenState();
}

class _PartnerQuestScreenState extends State<PartnerQuestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rewardController = TextEditingController();

  // Questləri əlavə etmək üçün backend API çağırışı
  Future<void> _submitQuest() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('http://localhost:3000/api/quests');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": _titleController.text,
          "description": _descriptionController.text,
          "reward": int.tryParse(_rewardController.text) ?? 0,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data['message'])));
        // Formanı təmizləyin
        _titleController.clear();
        _descriptionController.clear();
        _rewardController.clear();
        // Yenidən questləri yükləmək və ya ekranı yeniləmək üçün setState() istifadə edə bilərsiniz.
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Quest əlavə edilmədi, zəhmət olmasa yenidən cəhd edin.",
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
          "Partnyor Quest İdarəetməsi",
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
                // Quest Başlığı
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Quest Başlığı",
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
                // Quest Təsviri
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Quest Təsviri",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "Təsviri daxil edin"
                              : null,
                ),
                SizedBox(height: 20),
                // Reward (qazanılan coin)
                TextFormField(
                  controller: _rewardController,
                  decoration: InputDecoration(
                    labelText: "Mükafat (coin)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Mükafatı daxil edin";
                    }
                    if (int.tryParse(value) == null) {
                      return "Yalnız rəqəm daxil edin";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Quest Əlavə Et düyməsi
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1E3A8A),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _submitQuest,
                  child: Text(
                    "Quest Əlavə Et",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Gələcəkdə əlavə olunan questlərin siyahısı da burada göstərilə bilər.
                // Məsələn, backend-dən questləri çəkib ListView ilə göstərmək.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
