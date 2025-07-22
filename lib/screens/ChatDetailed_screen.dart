import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machinetestlilac/Models/chatMessage_Model.dart';
import 'package:machinetestlilac/constants/colors.dart';
import 'package:machinetestlilac/constants/functions.dart';
import 'package:machinetestlilac/provider/mainProvider.dart';
import 'package:provider/provider.dart';

class ChatDetailedScreen extends StatelessWidget {
  String userName,userProfile,userId;
  int customerId;
  bool isOnline;
   ChatDetailedScreen({super.key,required this.userId,required this.customerId,required this.userName,required this.userProfile,required this.isOnline,});

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
      backgroundColor: Colors.grey.shade50,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: AppBar(
            // backgroundColor: whiteFFFF,
            backgroundColor: Colors.transparent,
            leadingWidth: 116,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
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
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                      image: DecorationImage(image: NetworkImage(userProfile,),fit: BoxFit.cover)
                  ),
                ),
              ],
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: brown,
                  ),),
                if(isOnline)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Online ",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: brown,
                      ),),
                    Container(width: 10,
                    height: 10,decoration: BoxDecoration(
                        shape: BoxShape.circle,color: Colors.green
                      ),)
                  ],
                ),
              ],
            ),

          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<MainProvider>(
              builder: (context12, mainProvider, _) {
                return FutureBuilder<List<ChatMessage>>(
                  future: mainProvider.getChatBetweenUsers(
                    senderId: int.parse(userId),
                    receiverId: customerId,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final chats = snapshot.data!;
                      return Column(
                        children: [
                          // Chat messages
                          chats.isEmpty?
                           Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.waving_hand, size: 55,color: Colors.yellow,),
                                Text('Say Hello!',style: GoogleFonts.poppins(
                                  fontSize: 15


                                ),),
                              ],
                            ),
                          ):
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                color: whiteFFFF,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    spreadRadius: 0.3,
                                    blurRadius: 1.5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  topLeft: Radius.circular(8),
                                ),
                              ),
                              child: ListView.builder(
                                padding: const EdgeInsets.only(top: 15, bottom: 10),
                                itemCount: chats.length,
                                reverse: true, // Shows latest at bottom
                                itemBuilder: (context, index) {
                                  final chat = chats[index];
                                  final isSentByMe =
                                      chat.attributes.senderId.toString() == mainProvider.loginUserId;

                                  return Align(
                                    alignment: isSentByMe
                                        ? Alignment.topRight
                                        : Alignment.topLeft,
                                    child: Column(
                                      crossAxisAlignment: isSentByMe
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 10,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSentByMe
                                                ? darkRed6E
                                                : Colors.grey.shade300,
                                            borderRadius: BorderRadius.only(
                                              topLeft: const Radius.circular(8),
                                              topRight: const Radius.circular(8),
                                              bottomLeft: Radius.circular(isSentByMe ? 8 : 0),
                                              bottomRight: Radius.circular(isSentByMe ? 0 : 8),
                                            ),
                                          ),
                                          child: Text(
                                            chat.attributes.message ?? '',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: isSentByMe
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 14,
                                            left: 14,
                                            bottom: 6,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: isSentByMe
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                formatTime(chat.attributes.createdAt),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              if (isSentByMe) ...[
                                                const SizedBox(width: 4),
                                                Image.asset(
                                                  'assets/doubleTick.png',
                                                  scale: 2.1,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // Message Input Field
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 15,
                            ),
                            child: TextFormField(
                              minLines: 1,
                              maxLines: 4,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: 'Message',
                                fillColor: Colors.grey.shade200,
                                suffixIcon: const Icon(Icons.send, color: darkRed50),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade100),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
            ),
          ),




        ],
      ),
    );
  }
}
String formatTime(String? isoTime) {
  if (isoTime == null) return '';
  final dt = DateTime.tryParse(isoTime);
  if (dt == null) return '';
  final formatted = TimeOfDay.fromDateTime(dt);
  final hour = formatted.hourOfPeriod == 0 ? 12 : formatted.hourOfPeriod;
  final period = formatted.period == DayPeriod.am ? 'am' : 'pm';
  return '$hour:${formatted.minute.toString().padLeft(2, '0')} $period';
}
