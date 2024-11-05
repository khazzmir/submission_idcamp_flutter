import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  void _previousMonth() {
    setState(() {
      if (selectedMonth > 1) {
        selectedMonth--;
      } else {
        selectedYear--;
        selectedMonth = 12;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (selectedMonth < 12) {
        selectedMonth++;
      } else {
        selectedYear++;
        selectedMonth = 1;
      }
    });
  }

  String _monthName(int month) {
    const monthNames = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return monthNames[month - 1];
  }
  
  void _showMonthPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pilih Bulan", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: 12,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _monthName(index + 1),
                    style: GoogleFonts.poppins(),
                  ),
                  onTap: () {
                    setState(() {
                      selectedMonth = index + 1;
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    onPressed: _previousMonth,
                  ),
                  GestureDetector(
                    onTap: _showMonthPicker,
                    child: Text(
                      "${_monthName(selectedMonth)} $selectedYear",
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}