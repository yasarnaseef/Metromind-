
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machinetestlilac/constants/colors.dart';
import 'package:machinetestlilac/constants/functions.dart';
import 'package:machinetestlilac/constants/widgets.dart';
import 'package:machinetestlilac/provider/mainProvider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
            child: Text("Enter your phone \nnumber",
              textAlign: TextAlign.center,
              style: GoogleFonts.jost(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.black
              ,
            ),),
          ),
          SizedBox(height: 26,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Phone number field
                Consumer<MainProvider>(
                    builder: (context2,mainProvider,_) {
                    return Expanded(
                      child: TextFormField(
                        controller: mainProvider.phoneNumberController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Row(
                             children: [
                               const Icon(Icons.phone_android_outlined,color: Colors.black,size: 20,),
                               Text(" +91",
                                 textAlign: TextAlign.center,
                                 style: GoogleFonts.poppins(
                                   fontSize: 12,
                                   fontWeight: FontWeight.w400,
                                   color:brown
                                   ,
                                 ),),
                               const Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,),

                             ],
                                                 ),
                                VerticalDivider(endIndent: 15,indent: 15,color: Colors.grey,thickness: 1,)
                              ],
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints.tight(Size(100,50)),
                          hintText: 'Phone number',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(color: Colors.grey)
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        // onChanged: _onInputChanged,
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23),
            child: Text("Fliq will send you a text with a verification code.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color:brown
              ,
            ),),
          ),
          const Spacer(flex: 10),
        ],
      ),
floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Consumer<MainProvider>(
        builder: (context1,mainProvider,_) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child:mainProvider.loading
                ? const CircularProgressIndicator(color: darkRed):
            floatingButton(
              label: 'Next',
              gradient: const LinearGradient(
                colors: [lightRed,darkRed],
              ),
                onPressed:(){
                  mainProvider.sendOtp(context);
                },
            ),
          );
        }
      ),
    );
  }
}
