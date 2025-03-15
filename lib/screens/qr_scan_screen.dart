import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanScreen extends StatefulWidget {
  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    // Platforma dəyişikliklərinə görə kameranı dayandırıb yenidən başladaq
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (mounted) {
        setState(() {
          result = scanData;
        });
        // QR kod skan edildikdən sonra nəticəni geri qaytarırıq.
        Navigator.pop(context, result?.code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QR Kod Scan",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1E3A8A)),
      ),
      body: Column(
        children: <Widget>[
          // QR View üçün geniş ekran bölməsi
          Expanded(
            flex: 4,
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          ),
          // Tarama nəticəsini göstərən bölmə
          Expanded(
            flex: 1,
            child: Center(
              child:
                  (result != null)
                      ? Text(
                        'QR Kod: ${result!.code}',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                      )
                      : Text(
                        'QR kodunu tarayın',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
