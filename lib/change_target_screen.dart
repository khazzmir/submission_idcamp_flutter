import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangeTargetScreen extends StatefulWidget {
  @override
  _ChangeTargetScreenState createState() => _ChangeTargetScreenState();
}

class _ChangeTargetScreenState extends State<ChangeTargetScreen> {
  final TextEditingController _targetController = TextEditingController();
  int _currentTarget = 0;

  @override
  void initState() {
    super.initState();
    _currentTarget = 1000; 
    _targetController.text = _currentTarget.toString();
  }

  void _updateTarget() {
    int newTarget = int.tryParse(_targetController.text) ?? 0;
    setState(() {
      _currentTarget = newTarget;
    });
    Navigator.pop(context, _currentTarget); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          title: Center(
              child: Text("Ubah Target Harian",
                  style:
                      GoogleFonts.poppins(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600))),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/AppBar.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Masukkan Target Harian Anda:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Target Harian',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTarget,
              child: const Text('Simpan Target'),
            ),
          ],
        ),
      ),
    );
  }
}
