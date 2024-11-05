import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:submission_idcamp_flutter/line_chart_average.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  int activeContainer = 1;
  int selectedWeek = 1;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  int _calculateCalendarWeek(DateTime date) {
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    int offset = (firstDayOfMonth.weekday - DateTime.sunday) % 7;
    int daysSinceFirstSunday = date.day + offset - 1;
    return min((daysSinceFirstSunday / 7).floor() + 1, 5);
  }

  List<DateTime> getDatesOfSelectedWeek() {
    DateTime firstDayOfMonth = DateTime(selectedYear, selectedMonth, 1);
    DateTime firstDayOfWeek =
        firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday % 7));

    firstDayOfWeek = firstDayOfWeek.add(Duration(days: (selectedWeek - 1) * 7));

    List<DateTime> dates = [];
    for (int i = 0; i < 7; i++) {
      DateTime date = firstDayOfWeek.add(Duration(days: i));
      if (date.month == selectedMonth) dates.add(date);
    }
    return dates;
  }

  int _maxWeeksInMonth(int month, int year) {
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
    DateTime firstSunday =
        firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday % 7));
    int totalDays = lastDayOfMonth.day;
    int daysCount =
        totalDays + (firstSunday.day - 1);
    int weeksCount = (daysCount / 7).ceil();

    return weeksCount > 5 ? 5 : weeksCount;
  }

  void _previousPeriod() {
    setState(() {
      if (activeContainer == 1) {
        if (selectedWeek > 1) {
          selectedWeek--;
        } else if (selectedMonth > 1) {
          selectedMonth--;
          selectedWeek = _maxWeeksInMonth(selectedMonth, selectedYear);
        } else {
          selectedYear--;
          selectedMonth = 12;
          selectedWeek = _maxWeeksInMonth(selectedMonth, selectedYear);
        }
      } else if (activeContainer == 2 && selectedMonth > 1) {
        selectedMonth--;
      } else if (activeContainer == 3) {
        selectedYear--;
      }
    });
  }

  void _nextPeriod() {
  setState(() {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;

    bool isAtCurrentMonth = selectedYear == currentYear && selectedMonth == currentMonth;

    if (isAtCurrentMonth) return;

    if (activeContainer == 1) {
      int maxWeeks = _maxWeeksInMonth(selectedMonth, selectedYear);
      if (selectedWeek < maxWeeks) {
        selectedWeek++;
      } else if (selectedMonth < 12) {
        selectedMonth++;
        selectedWeek = 1;
      } else {
        selectedYear++;
        selectedMonth = 1;
        selectedWeek = 1;
      }
    } else if (activeContainer == 2 && selectedMonth < 12) {
      selectedMonth++;
    } else if (activeContainer == 3) {
      selectedYear++;
    }
  });
}


  String _monthName(int month) {
    const monthNames = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> dates = getDatesOfSelectedWeek();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SingleChildScrollView(
        child: Container(
          height: 1000,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  for (int i = 1; i <= 3; i++)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => activeContainer = i),
                        child: Container(
                          decoration: BoxDecoration(
                            color: activeContainer == i
                                ? Colors.transparent
                                : Colors.white,
                            image: activeContainer == i
                                ? const DecorationImage(
                                    image:
                                        AssetImage('assets/active_button.png'),
                                    fit: BoxFit.fill)
                                : null,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      const Color(0xFFB5B5B5).withOpacity(0.3),
                                  offset: const Offset(0, 0),
                                  blurRadius: 5)
                            ],
                          ),
                          height: 45,
                          child: Center(
                            child: Text(
                              i == 1
                                  ? 'Mingguan'
                                  : i == 2
                                      ? 'Bulanan'
                                      : 'Tahunan',
                              style: GoogleFonts.poppins(
                                color: activeContainer == i
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 15),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                  height: 1,
                  width: double.maxFinite,
                  child: Container(color: const Color(0xFF3299E8))),
              const SizedBox(height: 30),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1), blurRadius: 10)
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_left),
                        onPressed: _previousPeriod),
                    GestureDetector(
                      onTap: _showDatePicker,
                      child: Text(
                        activeContainer == 1
                            ? "Minggu $selectedWeek, ${_monthName(selectedMonth)} $selectedYear"
                            : activeContainer == 2
                                ? "${_monthName(selectedMonth)} $selectedYear"
                                : "$selectedYear",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.arrow_right),
                        onPressed: _nextPeriod),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x36B5B5B5),
                              offset: Offset(0, 0),
                              blurRadius: 5),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 125,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Rata - Rata Minum",
                              style: GoogleFonts.poppins()),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "1750",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                      fontSize: 45),
                                ),
                                TextSpan(
                                  text: " ml",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x36B5B5B5),
                              offset: Offset(0, 0),
                              blurRadius: 5),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 125,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Persentase", style: GoogleFonts.poppins()),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "75",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                      fontSize: 45),
                                ),
                                TextSpan(
                                  text: " %",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const LineChartAverage()
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime(selectedYear, selectedMonth),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedMonth = date.month;
          selectedYear = date.year;
          selectedWeek = _calculateCalendarWeek(date);
        });
      }
    });
  }
}
