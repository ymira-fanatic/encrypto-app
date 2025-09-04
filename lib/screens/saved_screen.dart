import 'package:flutter/material.dart';
import '../services/db_service.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  late Future<List<Map<String, dynamic>>> _records;

  @override
  void initState() {
    super.initState();
    _records = DBService.instance.getAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _records,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No saved records yet."));
          }

          final records = snapshot.data!;
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text("Plaintext: ${record['plaintext']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ciphertext: ${record['ciphertext']}"),
                      Text("Time: ${record['timestamp']}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
