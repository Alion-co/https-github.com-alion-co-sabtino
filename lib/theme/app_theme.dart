import 'package:flutter/material.dart';
import 'app_colors.dart';


class AppTheme {


  static ThemeData light = ThemeData(

    useMaterial3: true,


    scaffoldBackgroundColor:
    AppColors.background,


    colorScheme:

    ColorScheme.fromSeed(

      seedColor:
      AppColors.primary,

    ),



    appBarTheme:

    const AppBarTheme(

      elevation: 0,

      centerTitle: true,

      backgroundColor:
      Colors.transparent,

      foregroundColor:
      AppColors.text,

    ),



    inputDecorationTheme:

    InputDecorationTheme(

      filled: true,

      fillColor:
      Colors.white,


      border:

      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(16),

        borderSide:
        BorderSide.none,

      ),

    ),



    elevatedButtonTheme:

    ElevatedButtonThemeData(

      style:

      ElevatedButton.styleFrom(

        backgroundColor:
        AppColors.primary,


        foregroundColor:
        Colors.white,


        minimumSize:
        const Size(
          double.infinity,
          52,
        ),


        shape:

        RoundedRectangleBorder(

          borderRadius:
          BorderRadius.circular(16),

        ),

      ),

    ),


  );


}