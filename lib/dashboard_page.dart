import 'package:flutter/material.dart';
import 'input_penjualan_page.dart';
import 'target_page.dart';
import 'riwayat_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Input Penjualan"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const InputPenjualanPage()));
              },
            ),
            ElevatedButton(
              child: const Text("Input Target"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const TargetPage()));
              },
            ),
            ElevatedButton(
              child: const Text("Riwayat Penjualan"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RiwayatPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
