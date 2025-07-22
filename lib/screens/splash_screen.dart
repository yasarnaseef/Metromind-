import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machinetestlilac/constants/functions.dart';
import 'package:machinetestlilac/screens/login_Screen.dart';

import '../constants/colors.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      callNextReplacement(LoginScreen(), context);
    });
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      body: Container(
        height:height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/splashBg.png'), fit: BoxFit.cover
        ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Spacer(flex: 1),

              Image.asset('assets/splashTop.png', scale: 1.2,),
              const SizedBox(height: 8),
              // Headline
              Text(
                'Connect. Meet. Love.',
                style: GoogleFonts.poppins(
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              // Sub-headline
              Text(
                'With Fliq Dating',
                style: GoogleFonts.poppins(
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 45),
              const Spacer(flex: 3),

              // Buttons
              socialButton(
                icon: Image.asset('assets/Google.png', scale: 1.2,),
                label: 'Sign in with Google',
                fontColor: Colors.black,
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              socialButton(
                icon: Image.asset('assets/facebook.png',scale: 1.2),

                label: 'Sign in with Facebook',
                bgColor: blue,
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              socialButton(
                icon: Image.asset('assets/Phone.png',scale: 1.2),
                label: 'Sign in with phone number',
                gradient: const LinearGradient(
                  colors: [lightRed,darkRed],
                ),
                onPressed: () {},
              ),

              const SizedBox(height: 24),

              // Legal text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  children: [
                     TextSpan(
                      text: 'By signing up, you agree to our ',
                         style: GoogleFonts.poppins(
                           fontSize: 13,
                           fontWeight: FontWeight.w400,
                           color: Colors.white,
                         )
                    ),
                    TextSpan(
                      text: 'Terms',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )
                    ),
                     TextSpan(text: '. See how we ',style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    )),
                     TextSpan(text: 'use your data in our ',  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),),
                    TextSpan(
                      text: 'Privacy Policy.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget socialButton({
    required Widget icon,
    required String label,
    Color fontColor = Colors.white,
    Gradient? gradient,
    Color bgColor = Colors.white,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: gradient ?? LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [bgColor, bgColor]),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // let gradient show
            shadowColor: Colors.transparent,     // no extra shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            minimumSize: const Size(double.infinity, 48),
          ).copyWith(
            // keeps ink splash on top of the gradient
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (states) => states.contains(MaterialState.pressed)
                  ? Colors.white24
                  : null,
            ),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: fontColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}