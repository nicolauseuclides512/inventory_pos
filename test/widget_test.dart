import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_pos/main.dart';

void main() {
  testWidgets('Aplikasi menampilkan Dashboard setelah login', (WidgetTester tester) async {
    // 🔹 Jalankan aplikasi tanpa `const`
    await tester.pumpWidget(MyApp());

    // 🔹 Tunggu hingga Future selesai
    await tester.pumpAndSettle();

    // 🔹 Pastikan UI memiliki tombol atau teks yang sesuai di HomeScreen
    expect(find.byType(HomeScreen), findsOneWidget);  // Pastikan HomeScreen muncul
    expect(find.textContaining("Dashboard"), findsOneWidget);  // Periksa teks yang lebih fleksibel
  });
}
