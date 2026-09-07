// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'about_page.dart';
import 'location_model.dart';
import 'saved_info_page.dart';
import 'services/database_service.dart';


void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: "ثبت اطلاعات",

      builder: (context, child) {

        return Directionality(

          textDirection: TextDirection.rtl,

          child: child!,

        );

      },

      home: const AddLocationPage(),

    );

  }

}





class AddLocationPage extends StatefulWidget {

  const AddLocationPage({super.key});


  @override
  State<AddLocationPage> createState() =>
      _AddLocationPageState();

}







class _AddLocationPageState extends State<AddLocationPage> {


  final nameController = TextEditingController();

  final addressController = TextEditingController();

  final phoneController = TextEditingController();



  final MapController mapController = MapController();



  LatLng selectedPosition = const LatLng(

    35.6892,

    51.3890,

  );





  Future<void> getCurrentLocation() async {


    bool serviceEnabled =
    await Geolocator.isLocationServiceEnabled();


    if (!serviceEnabled) {

      return;

    }



    LocationPermission permission =
    await Geolocator.checkPermission();



    if (permission == LocationPermission.denied) {

      permission =
      await Geolocator.requestPermission();

    }



    Position position =
    await Geolocator.getCurrentPosition(

      desiredAccuracy: LocationAccuracy.high,

    );



    setState(() {


      selectedPosition = LatLng(

        position.latitude,

        position.longitude,

      );


    });



    mapController.move(

      selectedPosition,

      17,

    );


  }








  Future<void> saveData() async {


    if(nameController.text.isEmpty){

      return;

    }



    await DatabaseService.insertLocation(

      LocationData(

        name: nameController.text,

        address: addressController.text,

        phone: phoneController.text,

        latitude: selectedPosition.latitude,

        longitude: selectedPosition.longitude,

      ),

    );



    nameController.clear();

    addressController.clear();

    phoneController.clear();



    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text(

          "اطلاعات ثبت شد",

        ),

      ),

    );


  }







  Widget buildField(

      String title,

      TextEditingController controller,

      ){

    return Padding(

      padding: const EdgeInsets.only(bottom: 12),

      child: TextField(

        controller: controller,

        textAlign: TextAlign.right,

        decoration: InputDecoration(

          labelText: title,

          border: const OutlineInputBorder(),

        ),

      ),

    );

  }






  Widget buildPhoneField(

      String title,

      TextEditingController controller,

      ){

    return Padding(

      padding: const EdgeInsets.only(bottom: 12),

      child: TextField(

        controller: controller,

        keyboardType: TextInputType.phone,

        inputFormatters: [

          FilteringTextInputFormatter.digitsOnly,

        ],

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
          "ثبت اطلاعات",
        ),

        centerTitle: true,


        actions: [

          IconButton(

            icon: const Icon(
              Icons.info_outline,
            ),

            onPressed: (){

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) => const AboutPage(),

                ),

              );

            },

          ),

        ],

      ),




      body: SingleChildScrollView(


        padding: const EdgeInsets.all(16),


        child: Column(


          children: [



            buildField(

              "نام",

              nameController,

            ),



            buildField(

              "آدرس",

              addressController,

            ),



            buildPhoneField(

              "شماره تماس",

              phoneController,

            ),





            SizedBox(

              height: 300,

              child: FlutterMap(

                mapController: mapController,


                options: MapOptions(

                  initialCenter: selectedPosition,

                  initialZoom: 14,

                ),



                children: [



                  TileLayer(

                    urlTemplate:

                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",


                    userAgentPackageName:

                    "com.example.data_collector",

                  ),




                  MarkerLayer(

                    markers: [


                      Marker(

                        point: selectedPosition,

                        child: const Icon(

                          Icons.location_on,

                          color: Colors.red,

                          size: 45,

                        ),

                      )

                    ],

                  )


                ],

              ),

            ),





            const SizedBox(height: 10),




            SizedBox(

              width: double.infinity,

              child: ElevatedButton.icon(

                onPressed: getCurrentLocation,

                icon: const Icon(

                  Icons.my_location,

                ),

                label: const Text(

                  "موقعیت فعلی من",

                ),

              ),

            ),




            const SizedBox(height: 10),





            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: saveData,

                child: const Text(

                  "افزودن و ثبت موقعیت",

                ),

              ),

            ),





            const SizedBox(height: 10),





            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: (){


                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) =>

                      const SavedInfoPage(),

                    ),

                  );


                },

                child: const Text(

                  "اطلاعات ثبت شده",

                ),

              ),

            ),



          ],

        ),

      ),

    );


  }


}