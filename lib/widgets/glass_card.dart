import 'package:flutter/material.dart';


class GlassCard extends StatelessWidget {


  final Widget child;


  const GlassCard({

    super.key,

    required this.child,

  });



  @override
  Widget build(BuildContext context) {


    return Container(


      decoration:BoxDecoration(

        color:
        Colors.white.withOpacity(.85),


        borderRadius:
        BorderRadius.circular(20),


        boxShadow:[


          BoxShadow(

            color:
            Colors.black.withOpacity(.05),

            blurRadius:20,

            offset:
            const Offset(0,8),

          )

        ],


      ),


      child:child,


    );


  }


}