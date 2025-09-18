import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InputPenjualanPage extends StatefulWidget {
  const InputPenjualanPage({super.key});

  @override
  State<InputPenjualanPage> createState() => _InputPenjualanPageState();
}

class _InputPenjualanPageState extends State<InputPenjualanPage> {
  final _penjualanController = TextEditingController();
  final _strukController = TextEditingController();

  Future<void> _simpan() async {
    if (_penjualanController.text.isEmpty || _strukController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap isi semua data")),
      );
      return;
    }

    await Supabase.instance.client.from('penjualan').insert({
      'tanggal': DateTime.now().toIso8601String(),
      'penjualan': int.parse(_penjualanController.text),
      'struk': int.parse(_strukController.text),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Input Penjualan")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _penjualanController,
              decoration: const InputDecoration(
                labelText: "Jumlah Penjualan (Rp)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _strukController,
              decoration: const InputDecoration(
                labelText: "Jumlah Struk",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _simpan,
              child: const Text("Simpan ke Database"),
            ),
          ],
        ),
      ),
    );
  }
}
