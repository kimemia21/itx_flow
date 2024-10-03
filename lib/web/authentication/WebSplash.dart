import 'dart:math';
import 'package:flutter/material.dart';
import 'package:itx/authentication/SignUp.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/web/authentication/SignUp.dart';
import 'package:itx/web/authentication/SignInWeb.dart';

class SplashScreenWeb extends StatefulWidget {
  const SplashScreenWeb({Key? key}) : super(key: key);

  @override
  _SplashScreenWebState createState() => _SplashScreenWebState();
}

class _SplashScreenWebState extends State<SplashScreenWeb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation only once
    _controller.forward().whenComplete(() {
      // Optionally, navigate to the next screen or perform any action here
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Adjust size based on screen width
          double containerWidth = min(constraints.maxWidth * 0.4, 400);
          double containerPadding = constraints.maxWidth * 0.05;
          double iconSize = min(constraints.maxWidth * 0.12, 60);
          double fontSizeTitle = min(constraints.maxWidth * 0.08, 40);
          double fontSizeSubtitle = min(constraints.maxWidth * 0.04, 16);

          return Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: containerWidth,
                padding: EdgeInsets.all(containerPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildRotatingLeaf(iconSize), // Adjust icon size
                    const SizedBox(height: 20),
                    Text(
                      'ITX',
                      style: TextStyle(
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your premier platform for trading tea and other fine products',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSizeSubtitle,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // _buildButton(,'Sign In', Colors.green),

                    _buildButton(() {
                      Globals.switchScreens(
                          context: context, screen: SignInWeb());
                    }, 'Sign In', Colors.green),

                    const SizedBox(height: 10),
                    _buildButton(() {
                      Globals.switchScreens(
                          context: context, screen: MainSignupWeb());
                    }, 'Create Account', Colors.green[100]!, Colors.green),
                    const SizedBox(height: 30),
                    // _buildBouncingDots(), // You might want to stop these after the animation
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRotatingLeaf(double size) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.linear)),
      child: Icon(
        Icons.eco,
        size: size,
        color: Colors.green,
      ),
    );
  }

  Widget _buildButton(VoidCallback onpress, String text, Color bgColor,
      [Color? textColor]) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onpress,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBouncingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // You may decide to remove bouncing after animation ends
            final double bounce = sin((_controller.value * 2 * 3.14159) +
                    (index * 1.0471975511965976)) *
                5;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.translate(
                offset: Offset(0, bounce),
                child: child,
              ),
            );
          },
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.green[300],
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}
