import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 243, 243),
      body: Stack(
        children: [
          // Main vector background (welcome.png)
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome.png',
              fit: BoxFit.cover,
            ),
          ),
          // Leaves decorations
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/lefttop_leaves.png',
              width: 100,
            ),
          ),
          Positioned(
            bottom: -50,
            left: -25,
            child: Image.asset(
              'assets/images/leaves_left.png',
              width: 120,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/leaves_right.png',
              width: 120,
            ),
          ),
          // Main content (text and buttons)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'to',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Water Management Partner',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Get Started button
                SizedBox(
                  width: 200,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.zero,
                      elevation: 4,
                      backgroundColor: const Color(0xFF2196F3),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Sign In link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have account? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
