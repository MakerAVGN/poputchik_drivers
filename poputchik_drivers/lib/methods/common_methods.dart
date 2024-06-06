import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommonMethods{
  checkConnectivity(BuildContext context) async {
    var connectionResult = await Connectivity().checkConnectivity();

    if (connectionResult != ConnectivityResult.wifi && connectionResult != ConnectivityResult.mobile) {
      if(!context.mounted) return;
      displaySnackBar("Отсутствует подключение к интернету", context);
    } else {
      // Проверка фактического доступа к интернету
      try {
        final response = await http.get(Uri.parse('https://www.google.com'));

        if (response.statusCode != 200) {
          displaySnackBar("Отсутствует доступ к интернету", context);
        }
      } catch (e) {
        displaySnackBar("Отсутствует доступ к интернету", context);
      }
    }
  }

  displaySnackBar(String messageText, BuildContext context){
    var snackBar = SnackBar(content: Text(messageText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}