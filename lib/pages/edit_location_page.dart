import 'package:flutter/material.dart';

import '../models/location_model.dart';
import '../services/database_service.dart';

import '../widgets/glass_field.dart';
import '../widgets/app_button.dart';
import '../widgets/page_background.dart';



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




class _EditLocationPageState
    extends State<EditLocationPage> {



  late TextEditingController nameController;

  late TextEditingController addressController;

  late TextEditingController phoneController;




  bool saving = false;



  @override
  void initState() {

    super.initState();


    nameController =
        TextEditingController(
          text: widget.location.name,
        );


    addressController =
        TextEditingController(
          text: widget.location.address,
        );


    phoneController =
        TextEditingController(
          text: widget.location.phone,
        );


  }



  @override
  void dispose() {

    nameController.dispose();

    addressController.dispose();

    phoneController.dispose();

    super.dispose();

  }






  Future<void> saveEdit() async {


    setState(() {

      saving = true;

    });



    final updated = LocationData(

      id: widget.location.id,

      name: nameController.text,

      type: widget.location.type,

      address: addressController.text,

      phone: phoneController.text,

      latitude: widget.location.latitude,

      longitude: widget.location.longitude,

    );




    await DatabaseService.updateLocation(

      updated,

    );



    if(!mounted) return;


    Navigator.pop(context);



  }







  @override
  Widget build(BuildContext context) {


    return Scaffold(


      extendBodyBehindAppBar: true,


      appBar: AppBar(


        title:

        const Text(

          "ویرایش اطلاعات",

          style: TextStyle(

            fontWeight: FontWeight.w700,

          ),

        ),


        centerTitle:true,


      ),




      body:


      PageBackground(


        child:

        SafeArea(


          child:

          Padding(


            padding:
            const EdgeInsets.all(16),



            child:

            Column(


              children: [



                GlassField(

                  title:"نام",

                  icon:
                  Icons.person_outline,

                  controller:
                  nameController,

                ),




                GlassField(

                  title:"آدرس",

                  icon:
                  Icons.home_outlined,

                  controller:
                  addressController,

                ),




                GlassField(

                  title:"شماره تماس",

                  icon:
                  Icons.phone_outlined,

                  controller:
                  phoneController,

                  phone:true,

                ),




                const SizedBox(height:10),





                AppButton(

                  title:

                  saving

                      ? "در حال ذخیره..."

                      : "ذخیره تغییرات",


                  icon:
                  Icons.save_outlined,


                  primary:true,


                  onPressed:

                  saving

                      ? null

                      : saveEdit,


                ),



              ],


            ),


          ),


        ),


      ),


    );


  }


}