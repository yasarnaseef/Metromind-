import 'package:flutter/material.dart';

callNext(var className, var context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => className,),
  );
}
void callNextReplacement(Widget page, BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => page));
}
back(var context) {
  Navigator.pop(context);
}