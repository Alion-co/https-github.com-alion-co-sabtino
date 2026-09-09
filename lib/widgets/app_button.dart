import 'package:flutter/material.dart';

import '../theme/app_colors.dart';


class AppButton extends StatelessWidget {


  final String title;

  final IconData icon;

  final VoidCallback? onPressed;

  final bool primary;



  const AppButton({

    super.key,

    required this.title,

    required this.icon,

    required this.onPressed,

    this.primary = false,

  });



  @override
  Widget build(BuildContext context) {


    return SizedBox(

      width: double.infinity,

      height:52,


      child: primary


          ? FilledButton.icon(

        onPressed:onPressed,


        icon:Icon(icon),


        label:Text(

          title,

          style:const TextStyle(

            fontWeight:
            FontWeight.w600,

          ),

        ),


        style:FilledButton.styleFrom(

          backgroundColor:
          AppColors.primary,


          shape:
          RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(16),

          ),

        ),


      )



          : OutlinedButton.icon(

        onPressed:onPressed,


        icon:Icon(icon),


        label:Text(title),


        style:OutlinedButton.styleFrom(

          foregroundColor:
          AppColors.primary,


          shape:
          RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(16),

          ),

        ),


      ),


    );


  }


}