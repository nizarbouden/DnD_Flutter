import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final VoidCallback onTimeout;

  const SplashScreen({Key? key, required this.onTimeout}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  double _progress = 0.0;
  bool _loadingComplete = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Démarrer l'animation de chargement
    _startLoading();

    // Délai avant de naviguer
    Future.delayed(Duration(seconds: 3), () {
      if (_loadingComplete) {
        widget.onTimeout();
      }
    });
  }

  void _startLoading() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_progress < 1.0) {
          _progress += 0.01;
        } else {
          _loadingComplete = true;
          timer.cancel();
        }
      });
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadingTips = [
      "Embrace Role-play: Dive into your character’s quirks for a more immersive experience.",
      "Team Up: Collaborate with your party to develop effective strategies.",
      "Ask Questions: Clarify rules or plot points with the DM or players if you’re unsure.",
      "Take Notes: Keep track of important details, NPCs, and plot points to stay engaged.",
      "Be Creative: Use your spells and abilities in unique ways for unexpected solutions.",
      "Use Props: Bring items related to your character to enhance role-play.",
      "Balance Gameplay: Mix combat and role-play to keep the game dynamic.",
      "Have Fun: Enjoy the game and embrace silly moments.",
      "Support Others: Encourage teammates by building on their ideas during play.",
      "Stay Flexible: Adapt your plans as the story unfolds; embrace the unexpected!"
    ];

    final currentTip = (loadingTips..shuffle()).first;

    return Scaffold(
      body: Stack(
        children: [
          // Animation Lottie en arrière-plan
          Positioned.fill(
            child: Image.asset(
              'assets/final_loading.gif', // Assurez-vous que ce fichier est bien présent dans le dossier assets
              fit: BoxFit.cover,
            ),
          ),

          // Fond avec transition de couleur
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                color: Color.lerp(
                  Colors.grey[700],
                  Colors.grey[800],
                  _controller.value,
                ),
              );
            },
          ),

          // Texte de titre animé
          Positioned(
            top: 48.0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Dungeon Master",
                style: TextStyle(
                  fontFamily: 'VecnaBold_4yy4',
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ),

          // Barre de progression et interaction
          Positioned(
            bottom: 48.0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_loadingComplete)
                  Column(
                    children: [
                      Text(
                        "Loading... ${(_progress * 100).toInt()}%",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7A393D)),
                      ),
                    ],
                  )
                else
                  GestureDetector(
                    onTap: widget.onTimeout,
                    child: Text(
                      "Click to Continue",
                      style: TextStyle(
                        fontFamily: 'VecnaBold_4yy4',
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    currentTip,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
