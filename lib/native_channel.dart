
import 'dart:async';

import 'package:flutter/services.dart';

class NativeChannel{
  static const platform = MethodChannel('justaChannelName');

  static Future<String?> myMethod() async{
    try{
      final String result = await platform.invokeMethod('myMethod');
      print(result);
    }on PlatformException catch(e){
      return "Error: ${e.message}";
    }
  }
}