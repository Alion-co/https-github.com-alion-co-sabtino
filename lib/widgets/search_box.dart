import 'package:flutter/material.dart';


class SearchBox extends StatelessWidget {

  final TextEditingController controller;

  final Function(String) onChanged;


  const SearchBox({

    super.key,

    required this.controller,

    required this.onChanged,

  });



  @override
  Widget build(BuildContext context) {


    return Container(

      margin: const EdgeInsets.symmetric(

        horizontal: 14,

        vertical: 8,

      ),


      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withValues(alpha: .05),

            blurRadius: 15,

            offset: const Offset(0,5),

          )

        ],

      ),



      child: TextField(

        controller: controller,

        onChanged: onChanged,

        textAlign: TextAlign.right,


        decoration: const InputDecoration(


          hintText:

          "جستجو بر اساس نام، نوع، آدرس یا شماره",


          prefixIcon:

          Icon(

            Icons.search,

          ),


          border:

          InputBorder.none,


          contentPadding:

          EdgeInsets.all(16),


        ),

      ),

    );


  }


}