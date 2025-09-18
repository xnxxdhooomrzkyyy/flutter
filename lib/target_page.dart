import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TargetPage extends StatefulWidget {
  const TargetPage({super.key});

  @override
  State<TargetPage> createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  final _targetHarianController = TextEditingController();
  int targetBulanan = 0;

  Future<void> _simpan() async {
    if (_targetHarianController.text.isEmpty) return;

    int targetHarian = int.parse(_targetHarianController.text);
    targetBulanan = targetHarian * 31;

    await Supabase.instance.client.from('target').insert({
      'tanggal_input': DateTime.now().toIso8601String(),
      'target_harian': targetHarian,
      'target_bulanan': targetBulanan,
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Input Target")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _targetHarianController,
              decoration: const InputDecoration(
                labelText: "Target Harian (Rp)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            ElevatedButton(onPressed: _simpan, child: const Text("Simpan")),
            const SizedBox(height: 20),
            if (targetBulanan > 0)
              Text("Target Bulanan: Rp $targetBulanan",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
