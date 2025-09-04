// lib/screens/encrypt_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/db_service.dart';

class EncryptScreen extends StatefulWidget {
  const EncryptScreen({super.key});

  @override
  State<EncryptScreen> createState() => _EncryptScreenState();
}

class _EncryptScreenState extends State<EncryptScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _ciphertext;
  bool _loading = false;

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _encrypt() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _showMessage("Please enter text to encrypt.");
      return;
    }
    setState(() => _loading = true);
    try {
      final result = await ApiService.instance.encryptText(text);
      setState(() => _ciphertext = result);
    } catch (e) {
      _showMessage("Error: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (_ciphertext == null) return;
    await DBService.instance.insertData(
      plaintext: _controller.text.trim(),
      ciphertext: _ciphertext!,
    );
    _showMessage("Saved to database");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Encrypt")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter text to encrypt",
              ),
              minLines: 1,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _encrypt,
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
            if (_ciphertext != null) ...[
              SelectableText("Ciphertext: $_ciphertext"),
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

