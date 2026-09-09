import 'package:flutter/material.dart';


class EmptyState extends StatelessWidget {


  final String message;


  const EmptyState({

    super.key,

    required this.message,

  });





  @override
  Widget build(BuildContext context) {


    return Center(


      child: Padding(

        padding: const EdgeInsets.all(30),


        child: Column(


          mainAxisSize:

          MainAxisSize.min,



          children: [



            Container(


              width: 90,

              height: 90,



              decoration: BoxDecoration(


                color:

                Colors.blue.withValues(alpha: .1),


                shape:

                BoxShape.circle,


              ),



              child: const Icon(


                Icons.folder_open_outlined,


                size: 45,


                color: Colors.blue,


              ),



            ),




            const SizedBox(height: 20),




            Text(


              message,


              textAlign:

              TextAlign.center,



              style: TextStyle(


                color:

                Colors.grey.shade600,


                fontSize: 15,


              ),



            ),



          ],



        ),


      ),


    );


  }


}