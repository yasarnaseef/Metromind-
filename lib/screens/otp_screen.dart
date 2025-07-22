import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machinetestlilac/constants/colors.dart';
import 'package:machinetestlilac/constants/functions.dart';
import 'package:machinetestlilac/provider/mainProvider.dart';
import 'package:machinetestlilac/screens/chat_screen.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 55,
      height: 55,
      textStyle:
      TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(12),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return  Scaffold(
      backgroundColor: whiteFFFF,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: whiteFFFF,
            leadingWidth: 60,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child:  InkWell(
                onTap: (){
                  back(context);
                },
                child: Container(
                    height: 36,
                    width: 36,
                    margin: EdgeInsets.only(left: 9),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: whiteFFFF,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 0.2,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black87,size: 25,weight: 1,)),
              ),
            ),
          ),
          SizedBox(height: 24,),
          Center(
            child: Text("Enter your verification \ncode",
              textAlign: TextAlign.center,
              style: GoogleFonts.jost(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black
                ,
              ),),
          ),
          SizedBox(height: 24,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:   RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                      text: '+91 98745 61230. ',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      )
                  ),
                  TextSpan(
                      text: 'Edit',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )
                  ),

                ],
              ),
            ),
          ),
          SizedBox(height: 14,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child:Consumer<MainProvider>(
                builder: (context1,mainProvider,_) {
                return Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  // controller: authProvider.otpController,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onCompleted: (pin) async {
                    if(mainProvider.otpNumber==int.parse(pin)){
                      debugPrint('Received OTP: ${mainProvider.otpNumber}');

                      // 2. Verify
                      final result = await mainProvider.verifyOtp(mainProvider.otpNumber);
                      callNext(ChatScreen(), context);
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("entered wrong otp"),backgroundColor: Colors.red,),
                      );
                    }
                  },

                );
              }
            ),
          ),
          SizedBox(height: 22,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:   RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                      text: 'Didn’t get anything? No worries, let’s try again.\n',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      )
                  ),
                  TextSpan(

                      text: 'Resent',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      )
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

