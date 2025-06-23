// Import library utama dari Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Kita butuh ini untuk Platform Channel

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nikon Detector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variabel untuk menyimpan status koneksi kamera
  String _cameraStatus = "Belum dicek";
  
  // Mendefinisikan nama channel kita. Nama ini harus SAMA PERSIS di kode Kotlin nanti.
  static const platform = MethodChannel('com.example.nikon_detector/usb');

  // Fungsi yang akan dipanggil saat tombol ditekan
  Future<void> _cekKamera() async {
    String status;
    try {
      // Memanggil metode 'getUsbDeviceStatus' di sisi native (Kotlin)
      final String result = await platform.invokeMethod('getUsbDeviceStatus');
      status = result;
    } on PlatformException catch (e) {
      // Tangani jika ada error, misalnya plugin tidak ditemukan (saat run di web)
      status = "Gagal mendapatkan status: '${e.message}'.";
    }

    // Memperbarui state agar UI menampilkan status terbaru
    setState(() {
      _cameraStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nikon Detector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Status Kamera:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              _cameraStatus, // Teks ini akan berubah sesuai hasil pengecekan
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _cekKamera, // Panggil fungsi pengecekan saat ditekan
              child: const Text('Cek Kamera Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}
