import 'package:flutter/material.dart';

class PageBackground extends StatelessWidget {

  final Widget child;

  const PageBackground({
    super.key,
    required this.child,
  });


  @override
  Widget build(BuildContext context) {

    return Container(

      decoration: const BoxDecoration(

        gradient: LinearGradient(

          begin: Alignment.topRight,

          end: Alignment.bottomLeft,

          colors: [

            Color(0xffF7FBFF),

            Color(0xffEDF4FA),

            Color(0xffF7F9FC),

          ],

        ),

      ),


      child: child,

    );

  }

}