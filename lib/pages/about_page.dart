import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';


class AboutPage extends StatelessWidget {

  const AboutPage({super.key});


  @override
  Widget build(BuildContext context) {


    return Scaffold(

      extendBodyBehindAppBar: true,


      appBar: AppBar(

        backgroundColor: Colors.transparent,

        elevation: 0,

        centerTitle: true,


        title: const Text(

          "درباره ثبتینو",

          style: TextStyle(

            fontWeight: FontWeight.w700,

          ),

        ),

      ),



      body: Container(

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



        child: SafeArea(


          child: Padding(


            padding: const EdgeInsets.all(20),



            child: Column(


              children: [



                const SizedBox(height: 20),




                Container(


                  width: 100,

                  height: 100,



                  decoration: BoxDecoration(


                    color:
                    AppColors.primary.withOpacity(.12),


                    borderRadius:
                    BorderRadius.circular(30),



                    boxShadow: [


                      BoxShadow(

                        color:
                        AppColors.primary.withOpacity(.12),

                        blurRadius: 25,

                        offset:
                        const Offset(0,10),

                      )

                    ],


                  ),




                  child: Icon(


                    Icons.location_on_rounded,


                    size: 55,


                    color:
                    AppColors.primary,


                  ),


                ),





                const SizedBox(height: 22),





                const Text(


                  "ثبتینو",


                  style: TextStyle(


                    fontSize: 32,


                    fontWeight:
                    FontWeight.bold,


                    color:
                    AppColors.text,


                  ),


                ),





                const SizedBox(height: 8),





                Text(


                  "مدیریت و ثبت هوشمند اطلاعات",


                  style: TextStyle(


                    fontSize: 15,


                    color:
                    AppColors.secondaryText,


                  ),


                ),





                const SizedBox(height: 35),






                infoCard(

                  Icons.code_rounded,

                  "ساخته شده توسط",

                  "ALION",

                ),





                const SizedBox(height: 12),





                infoCard(

                  Icons.lightbulb_outline_rounded,

                  "ایده و طراح",

                  "سجاد مظهری",

                ),





                const SizedBox(height: 12),





                infoCard(

                  Icons.phone_rounded,

                  "شماره تماس",

                  "09142745663",

                ),






                const Spacer(),





                Text(


                  "نسخه 1.0.2",


                  style: TextStyle(


                    color:
                    AppColors.secondaryText,


                    fontSize: 13,


                  ),


                ),





                const SizedBox(height: 20),



              ],


            ),


          ),


        ),


      ),


    );


  }









  Widget infoCard(

      IconData icon,

      String title,

      String value,

      ) {


    return GlassCard(


      child: Padding(


        padding:
        const EdgeInsets.all(18),



        child: Row(


          children: [



            Container(


              width: 46,


              height: 46,



              decoration: BoxDecoration(


                color:
                AppColors.primary.withOpacity(.12),



                borderRadius:
                BorderRadius.circular(15),


              ),



              child: Icon(


                icon,


                color:
                AppColors.primary,


              ),


            ),





            const SizedBox(width: 15),





            Column(


              crossAxisAlignment:
              CrossAxisAlignment.start,



              children: [



                Text(


                  title,


                  style: TextStyle(


                    color:
                    AppColors.secondaryText,


                    fontSize: 13,


                  ),


                ),





                const SizedBox(height: 5),





                Text(


                  value,


                  style: const TextStyle(


                    fontSize: 17,


                    fontWeight:
                    FontWeight.w700,


                    color:
                    AppColors.text,


                  ),


                ),



              ],


            ),



          ],


        ),


      ),


    );


  }


}