// lib/edit_location_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'location_model.dart';
import 'services/database_service.dart';



class EditLocationPage extends StatefulWidget {


  final LocationData location;


  const EditLocationPage({

    super.key,

    required this.location,

  });



  @override
  State<EditLocationPage> createState() =>
      _EditLocationPageState();


}






class _EditLocationPageState extends State<EditLocationPage> {



  late TextEditingController nameController;

  late TextEditingController addressController;

  late TextEditingController phoneController;





  @override
  void initState() {

    super.initState();


    nameController = TextEditingController(

      text: widget.location.name,

    );


    addressController = TextEditingController(

      text: widget.location.address,

    );


    phoneController = TextEditingController(

      text: widget.location.phone,

    );


  }






  Future<void> saveEdit() async {


    final updated = LocationData(


      id: widget.location.id,


      name: nameController.text,


      address: addressController.text,


      phone: phoneController.text,


      latitude: widget.location.latitude,


      longitude: widget.location.longitude,


    );




    await DatabaseService.updateLocation(

      updated,

    );



    Navigator.pop(context);


  }







  Widget field(

      String title,

      TextEditingController controller,

      {bool number = false}

      ){


    return Padding(

      padding: const EdgeInsets.only(bottom: 12),


      child: TextField(


        controller: controller,


        keyboardType: number

            ? TextInputType.phone

            : TextInputType.text,



        inputFormatters: number

            ? [

          FilteringTextInputFormatter.digitsOnly,

        ]

            : null,



        textAlign: TextAlign.right,


        decoration: InputDecoration(

          labelText: title,

          border: const OutlineInputBorder(),

        ),


      ),


    );


  }








  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(


        title: const Text(

          "ویرایش اطلاعات",

        ),


        centerTitle: true,


      ),




      body: Padding(


        padding: const EdgeInsets.all(16),


        child: Column(


          children: [



            field(

              "نام",

              nameController,

            ),




            field(

              "آدرس",

              addressController,

            ),




            field(

              "شماره تماس",

              phoneController,

              number: true,

            ),





            SizedBox(


              width: double.infinity,


              child: ElevatedButton(


                onPressed: saveEdit,


                child: const Text(

                  "ذخیره تغییرات",

                ),


              ),


            )



          ],


        ),


      ),


    );


  }


}