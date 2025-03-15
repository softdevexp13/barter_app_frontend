import 'package:flutter/material.dart';

class LegalPartnerLoginScreen extends StatefulWidget {
  @override
  _LegalPartnerLoginScreenState createState() =>
      _LegalPartnerLoginScreenState();
}

class _LegalPartnerLoginScreenState extends State<LegalPartnerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Burada backend-ə API çağırışı və digər giriş məntiqini əlavə edə bilərsiniz.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hüquqi Partnyor uğurla daxil oldu!")),
      );
      // Giriş uğurlu olduqda, növbəti ekrana yönləndirmə və ya token idarəsi əlavə edin.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hüquqi Partnyor Girişi",
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _companyIdController,
                decoration: InputDecoration(
                  labelText: "Şirkət/Qurum Nömrəsi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Nömrəni daxil edin"
                            : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Şifrə",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                obscureText: true,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Şifrə daxil edin"
                            : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E3A8A),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Daxil Ol",
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
    );
  }
}
