import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/logs/screens/log_screen.dart';
import 'features/reports/screens/report_screen.dart';
import 'features/inventory/screens/inventory_screen.dart';
import 'features/transactions/screens/transaction_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory POS System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: AuthCheck(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/logs': (context) => LogScreen(),
        '/reports': (context) => ReportScreen(),
        '/inventory': (context) => InventoryScreen(),
        '/transactions': (context) => TransactionsScreen(),
      },
    );
  }
}

// 🔹 Cek apakah user sudah login
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token'); // Jika token ada, user sudah login
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator())); // 🔄 Loading
        } else if (snapshot.hasData && snapshot.data == true) {
          return HomeScreen(); // Jika sudah login, masuk ke Home
        } else {
          return LoginScreen(); // Jika belum login, masuk ke Login
        }
      },
    );
  }
}

// 🔹 Halaman Home setelah login
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/inventory'),
              child: Text("📦 Manajemen Inventaris"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/transactions'),
              child: Text("💰 Transaksi"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/reports'),
              child: Text("📊 Laporan"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/logs'),
              child: Text("📜 Log Aktivitas"),
            ),
            ElevatedButton(
              onPressed: () => logout(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("🚪 Logout"),
            ),
          ],
        ),
      ),
    );
  }

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Hapus token login
    Navigator.pushReplacementNamed(context, '/login');
  }
}
