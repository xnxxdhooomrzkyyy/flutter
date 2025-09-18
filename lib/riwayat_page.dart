import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<Map<String, dynamic>> data = [];
  int targetBulanan = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final penjualan = await Supabase.instance.client
        .from('penjualan')
        .select()
        .order('tanggal', ascending: true);

    final target = await Supabase.instance.client
        .from('target')
        .select()
        .order('tanggal_input', ascending: false)
        .limit(1);

    setState(() {
      data = List<Map<String, dynamic>>.from(penjualan);
      if (target.isNotEmpty) {
        targetBulanan = target[0]['target_bulanan'];
      }
    });
  }

  Future<void> _exportPDF() async {
    final pdf = pw.Document();

    int totalPendapatan =
        data.fold(0, (sum, item) => sum + (item['penjualan'] as int));
    double persentase = targetBulanan > 0
        ? (totalPendapatan / targetBulanan) * 100
        : 0;

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Laporan Penjualan",
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ["Tanggal", "Penjualan (Rp)", "Struk"],
              data: data
                  .map((item) => [
                        DateFormat("dd-MM-yyyy")
                            .format(DateTime.parse(item['tanggal'])),
                        item['penjualan'].toString(),
                        item['struk'].toString(),
                      ])
                  .toList(),
            ),
            pw.SizedBox(height: 15),
            pw.Text("Total Pendapatan: Rp $totalPendapatan"),
            pw.Text("Target Bulanan: Rp $targetBulanan"),
            pw.Text("Pencapaian: ${persentase.toStringAsFixed(1)} %"),
          ],
        ),
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Laporan-Penjualan.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Penjualan"),
        actions: [
          if (data.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: _exportPDF,
            )
        ],
      ),
      body: data.isEmpty
          ? const Center(child: Text("Belum ada data penjualan"))
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long, color: Colors.blue),
                    title: Text("Rp ${item['penjualan']} - Struk: ${item['struk']}"),
                    subtitle: Text(DateFormat("dd-MM-yyyy")
                        .format(DateTime.parse(item['tanggal']))),
                  ),
                );
              },
            ),
    );
  }
}
