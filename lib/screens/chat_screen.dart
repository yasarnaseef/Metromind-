import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machinetestlilac/Models/customer_model.dart';
import 'package:machinetestlilac/constants/colors.dart';
import 'package:machinetestlilac/constants/functions.dart';
import 'package:machinetestlilac/provider/mainProvider.dart';
import 'package:machinetestlilac/screens/ChatDetailed_screen.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
      appBar: AppBar(
        backgroundColor: whiteFFFF,
        leading:   InkWell(
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
        title: Text("Messages",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color:brown
            ,
          ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Consumer<MainProvider>(
              builder: (context12,mainProvider,_) {
                // mainProvider.getChatProfiles();
                return SizedBox(
                  width:width,
                  height: 90,
                  child:  FutureBuilder<List<Customer>>(
                      future: mainProvider.getChatProfiles(),
                      builder: (context1, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          final customers = snapshot.data!;
                      return ListView.builder(
                        itemCount: customers.length,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context22,index){
                            final customer = customers[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 24),
                            child: Column(
                              children: [
                                Container(
                                  width: 55,
                                  height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: NetworkImage(customer.attributes.profilePhotoUrl!,),fit: BoxFit.cover)
                                ),
                                ),
                                Text(customer.attributes.name!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color:brown
                                    ,
                                  ),),

                              ],
                            ),
                          );
                          });}
                    }
                  ),
                );
              }
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                // controller: _controller,
                decoration: InputDecoration(
                  hintText: ' Search',
                  suffixIcon: const Icon(Icons.search),
                  focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(30),
              ),
                  enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(30),
              ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15,top: 10),
              child: Text("Chat",
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: brown,
                ),),
            ),

            Consumer<MainProvider>(
                builder: (context12,mainProvider,_) {
                return FutureBuilder<List<Customer>>(
                    future: mainProvider.getChatProfiles(),
                    builder: (context1, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }else{
                        final customers = snapshot.data!;
                        return ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: customers.length,
                          itemBuilder: (BuildContext context, int index) {
                            final customer = customers[index];
                            return  Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3.3),
                              child: InkWell(
                                onTap: (){
                                  debugPrint("ddddddddd : "+customer.id);
                                  debugPrint("fffffffff : ${customer.attributes.userId!}");
                                  callNext(ChatDetailedScreen(userName: customer.attributes.name!,
                                    userProfile:customer.attributes.profilePhotoUrl!,userId:customer.id!,
                                    isOnline: customer.attributes.isOnline!, customerId: customer.attributes.userId! ,), context);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 3),
                                      child: Row(
                                        mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              // index % 2 == 1 ?
                                              Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(image: NetworkImage(customer.attributes.profilePhotoUrl!,),fit: BoxFit.cover)
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                // width: width*.55,
                                                child: Text(customer.attributes.name!,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.jost(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: brown,
                                                  ),),
                                              ),

                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:  EdgeInsets.only(top:height/60,right: 15),
                                                child:Text(mainProvider.convertToTime(customer.attributes.lastMessage!),
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: brown,
                                                  ),),

                                                // textWidPopins(
                                                //   // DateFormat('hh:mm aa').format(item.timeStamp) ,
                                                //   // "12:23 AM",
                                                //   blac,
                                                //   10,
                                                //   FontWeight.w400,
                                                // ),
                                              ),
                                              const SizedBox(height: 6),
                                              // const CircleAvatar(
                                              //   radius:3.5,
                                              //   backgroundColor: clr019010,
                                              // )
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      width: width,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(left: 10),
                                      height: 1,
                                      color: Colors.grey.shade200,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },

                        );
                      }

                  }
                );
              }
            )

          ],
        ),
      ),
    );
  }
}
