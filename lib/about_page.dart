import 'package:flutter/material.dart';


class AboutPage extends StatelessWidget {


  const AboutPage({super.key});



  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title: const Text(
          "درباره ثبتینو",
        ),

        centerTitle: true,

      ),




      body: Center(


        child: Padding(

          padding: const EdgeInsets.all(24),


          child: Column(


            mainAxisAlignment:

            MainAxisAlignment.center,


            children: [



              const Icon(

                Icons.location_on,

                size: 90,

                color: Colors.blue,

              ),




              const SizedBox(height: 20),




              const Text(

                "ثبتینو",

                style: TextStyle(

                  fontSize: 28,

                  fontWeight: FontWeight.bold,

                ),

              ),





              const SizedBox(height: 10),




              const Text(

                "مدیریت و ثبت اطلاعات",

                style: TextStyle(

                  fontSize: 16,

                ),

              ),





              const SizedBox(height: 40),





              const Text(

                "ساخته شده توسط",

                style: TextStyle(

                  fontSize: 15,

                ),

              ),




              const SizedBox(height: 8),




              const Text(

                "ALION",

                style: TextStyle(

                  fontSize: 22,

                  fontWeight: FontWeight.bold,

                ),

              ),





              const SizedBox(height: 8),





              const Text(

                "09142745663",

                style: TextStyle(

                  fontSize: 18,

                ),

              ),





              const SizedBox(height: 30),




              const Text(

                "نسخه 1.0.0",

                style: TextStyle(

                  color: Colors.grey,

                ),

              ),



            ],


          ),


        ),


      ),


    );


  }


}