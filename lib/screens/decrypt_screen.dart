// lib/screens/decrypt_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/db_service.dart';

class DecryptScreen extends StatefulWidget {
  const DecryptScreen({super.key});

  @override
  State<DecryptScreen> createState() => _DecryptScreenState();
}

class _DecryptScreenState extends State<DecryptScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _plaintext;
  bool _loading = false;

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _decrypt() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _showMessage("Please enter ciphertext to decrypt.");
      return;
    }
    setState(() => _loading = true);
    try {
      final result = await ApiService.instance.decryptText(text);
      setState(() => _plaintext = result);
    } catch (e) {
      _showMessage("Error: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (_plaintext == null) return;
    await DBService.instance.insertData(
      plaintext: _plaintext!,
      ciphertext: _controller.text.trim(),
    );
    _showMessage("Saved to database");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Decrypt")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter ciphertext to decrypt",
              ),
              minLines: 1,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _decrypt,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Enter"),
              ),
            ),
            const SizedBox(height: 20),
            if (_plaintext != null) ...[
              SelectableText("Plaintext: $_plaintext"),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text("Save"),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
