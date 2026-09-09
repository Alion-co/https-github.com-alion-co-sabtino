import 'package:flutter/material.dart';

import 'pages/add_location_page.dart';
import 'theme/app_theme.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: "ثبتینو",

      theme: AppTheme.light,

      builder: (context, child) {

        return Directionality(

          textDirection: TextDirection.rtl,

          child: child!,

        );

      },

      home: const AddLocationPage(),

    );

  }

}