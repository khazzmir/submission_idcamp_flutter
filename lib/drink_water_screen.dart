import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:submission_idcamp_flutter/change_target_screen.dart';
import 'database_helper.dart';

class DrinkWaterScreen extends StatefulWidget {
  const DrinkWaterScreen({super.key});

  @override
  State<DrinkWaterScreen> createState() => _DrinkWaterScreenState();
}

class _DrinkWaterScreenState extends State<DrinkWaterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _lottieController;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  int _currentDrink = 0;
  int _targetDrink = 2000;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _updateLottieAnimation();
  }

  void _updateLottieAnimation() {
    double progress = _currentDrink / _targetDrink; 
    int maxFrame = 110; 
    double frameProgress = progress * maxFrame; 

    frameProgress = frameProgress.clamp(
        0, maxFrame.toDouble()); 

    Duration duration;
    if (progress <= 0.25) {
      duration =
          Duration(milliseconds: 1000); 
    } else if (progress <= 0.75) {
      duration =
          Duration(milliseconds: 2000); 
    } else {
      duration = Duration(
          milliseconds: 5000); 
    }

    _lottieController.animateTo(
      frameProgress / maxFrame, 
      duration: duration, 
      curve: Curves.easeInOut, 
    );

    if (frameProgress >= maxFrame) {
      _lottieController
          .stop(); 
      _lottieController.value =
          maxFrame / maxFrame; 
    }
  }

  void _addDrink(int amount) {
    setState(() {
      _currentDrink += amount;
      if (_currentDrink > _targetDrink) {
        _currentDrink = _targetDrink; 
      }
      _updateLottieAnimation(); 
    });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  Future<void> _loadDrinkData() async {
    final drinkData = await _dbHelper.getDrinkData();
    setState(() {
      _currentDrink = drinkData['currentDrink'] ?? 0;
      _targetDrink = drinkData['targetDrink'] ?? 2000;
    });
  }

  void _openCustomGlassScreen() async {
    
  }

  void _openCustomTargetScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangeTargetScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFB5B5B5).withOpacity(0.2),
                            offset: const Offset(0, 0),
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "$_currentDrink",
                                style: GoogleFonts.poppins(
                                  fontSize: 37,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: " ml\n",
                                style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              TextSpan(
                                text: "dari\n",
                                style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              TextSpan(
                                text: "$_targetDrink",
                                style: GoogleFonts.poppins(
                                    fontSize: 37,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              TextSpan(
                                text: " ml",
                                style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 17),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _openCustomGlassScreen,
                          child:
                              _buildCustomButton("Custom Gelas", Icons.water),
                        ),
                        GestureDetector(
                          onTap: _openCustomTargetScreen,
                          child: _buildCustomButton(
                              "Custom Target", Icons.center_focus_strong),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 480,
                child: Stack(
                  children: [
                    _buildDrinkButton(
                        750, 'assets/botol.png', () => _addDrink(750),
                        width: 180, height: 180),
                    _buildDrinkButton(
                        350, 'assets/mug.png', () => _addDrink(350),
                        width: 140, height: 140),
                    _buildDrinkButton(
                        250, 'assets/gelas.png', () => _addDrink(250),
                        width: 120, height: 120),
                    Positioned(
                      top: 260,
                      left: 140,
                      child: Container(
                        height: 200,
                        width: 200,
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Background image
                                  Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/bg_percentage_drink.png'),
                                      ),
                                    ),
                                  ),
                                  Lottie.asset(
                                    'assets/water_fill.json', 
                                    width: 400,
                                    height: 400,
                                    animate: true,
                                    controller: _lottieController,
                                  ),
                                  Text(
                                    "${(_currentDrink / _targetDrink * 100).toInt()}%", 
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton(String text, IconData icon) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/button_drink.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$text ",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
              WidgetSpan(
                child: Icon(icon, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrinkButton(int amount, String imagePath, VoidCallback onTap,
      {double width = 140, double height = 140}) {
    return Positioned(
      top: amount == 750 ? 40 : (amount == 350 ? 70 : 270),
      left: amount == 350 ? 200 : 0,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text("+ $amount ml",
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
            const SizedBox(height: 10),
            Container(
              width: width,
              height: height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/button_glass.png')),
              ),
              child: Center(
                  child: Image.asset(imagePath,
                      height: height *
                          0.6)),
            ),
          ],
        ),
      ),
    );
  }
}
