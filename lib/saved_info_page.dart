// lib/saved_info_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'location_model.dart';
import 'services/database_service.dart';
import 'services/excel_service.dart';
import 'edit_location_page.dart';



class SavedInfoPage extends StatefulWidget {

  const SavedInfoPage({

    super.key,

  });


  @override
  State<SavedInfoPage> createState() =>
      _SavedInfoPageState();

}






class _SavedInfoPageState extends State<SavedInfoPage> {


  List<LocationData> locations = [];


  final Set<int> selectedIds = {};

  bool selectAll = false;



  @override
  void initState() {

    super.initState();

    loadData();

  }






  Future<void> loadData() async {


    final data =
    await DatabaseService.getLocations();


    setState(() {


      locations = data;


      selectedIds.clear();


      selectAll = false;


    });


  }







  void selectAllItems(bool value) {


    setState(() {


      selectAll = value;


      selectedIds.clear();



      if(value){


        for(var item in locations){


          if(item.id != null){

            selectedIds.add(item.id!);

          }


        }


      }


    });


  }







  Future<void> deleteSelected() async {


    if(selectedIds.isEmpty){

      return;

    }


    await DatabaseService.deleteLocations(

      selectedIds.toList(),

    );


    loadData();


  }







  Future<void> deleteAll() async {


    await DatabaseService.deleteAllLocations();


    loadData();


  }







  Future<void> editItem(LocationData item) async {


    await Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => EditLocationPage(

          location: item,

        ),

      ),

    );


    loadData();


  }







  @override
  Widget build(BuildContext context) {


    return Scaffold(



      appBar: AppBar(


        title: const Text(

          "اطلاعات ثبت شده",

        ),



        actions: [



          IconButton(

            icon: const Icon(

              Icons.file_download,

            ),

            onPressed: (){


              ExcelService.exportLocations(

                locations,

              );


            },

          ),





          PopupMenuButton(


            itemBuilder: (_) => [



              PopupMenuItem(

                onTap: (){


                  Future.delayed(

                    Duration.zero,

                    deleteSelected,

                  );


                },

                child: const Text(

                  "حذف انتخاب شده ها",

                ),

              ),





              PopupMenuItem(

                onTap: (){


                  Future.delayed(

                    Duration.zero,

                    deleteAll,

                  );


                },

                child: const Text(

                  "حذف همه",

                ),

              ),



            ],


          )


        ],


      ),






      body: Column(


        children: [



          CheckboxListTile(

            title: const Text(
              "انتخاب همه",
            ),

            value: selectAll,

            onChanged: (value) {

              selectAllItems(value ?? false);

            },

          ),






          Expanded(


            child: ListView.builder(


              itemCount: locations.length,


              itemBuilder: (context,index){


                final item = locations[index];


                final checked =

                selectedIds.contains(item.id);




                return Card(


                  margin:

                  const EdgeInsets.all(8),




                  child: Column(


                    children: [




                      CheckboxListTile(


                        value: checked,


                        onChanged: (value){


                          setState((){


                            if(value == true){

                              selectedIds.add(

                                  item.id!

                              );

                            }

                            else{

                              selectedIds.remove(

                                  item.id

                              );

                            }


                          });


                        },



                        title: Text(

                          item.name,

                        ),



                        subtitle: Column(

                          crossAxisAlignment:

                          CrossAxisAlignment.start,


                          children: [


                            Text(

                              item.address,

                            ),


                            Text(

                              item.phone,

                            ),


                          ],


                        ),



                      ),






                      Row(


                        mainAxisAlignment:

                        MainAxisAlignment.end,


                        children: [



                          IconButton(

                            icon: const Icon(

                              Icons.edit,

                            ),


                            onPressed: (){


                              editItem(item);


                            },


                          ),





                          IconButton(

                            icon: const Icon(

                              Icons.delete,

                            ),


                            onPressed: () async {


                              await DatabaseService.deleteLocation(

                                item.id!,

                              );


                              loadData();


                            },


                          ),




                          ElevatedButton(

                            onPressed: (){


                              Navigator.push(

                                context,

                                MaterialPageRoute(

                                  builder: (_) => MapViewPage(

                                    location: item,

                                  ),

                                ),

                              );


                            },


                            child: const Text(

                              "نقشه",

                            ),


                          )



                        ],


                      )



                    ],


                  ),


                );


              },


            ),


          )



        ],


      ),


    );


  }


}









class MapViewPage extends StatefulWidget {


  final LocationData location;



  const MapViewPage({

    super.key,

    required this.location,

  });



  @override
  State<MapViewPage> createState() =>
      _MapViewPageState();


}







class _MapViewPageState extends State<MapViewPage> {


  final MapController controller = MapController();


  LatLng? current;



  Future<void> getCurrent() async {



    Position position =

    await Geolocator.getCurrentPosition(

      desiredAccuracy:

      LocationAccuracy.high,

    );



    setState((){


      current = LatLng(

        position.latitude,

        position.longitude,

      );


    });



    controller.move(

      current!,

      17,

    );


  }







  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title: Text(

          widget.location.name,

        ),

      ),



      floatingActionButton:

      FloatingActionButton.extended(


        onPressed: getCurrent,


        icon: const Icon(

          Icons.my_location,

        ),


        label: const Text(

          "موقعیت من",

        ),


      ),




      body: FlutterMap(


        mapController: controller,



        options: MapOptions(

          initialCenter: LatLng(

            widget.location.latitude,

            widget.location.longitude,

          ),


          initialZoom: 16,

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

                point: LatLng(

                  widget.location.latitude,

                  widget.location.longitude,

                ),


                child: const Icon(

                  Icons.location_on,

                  color: Colors.red,

                  size: 45,

                ),

              ),




              if(current != null)


                Marker(

                  point: current!,

                  child: const Icon(

                    Icons.person_pin_circle,

                    color: Colors.blue,

                    size: 50,

                  ),

                ),



            ],

          )


        ],

      ),


    );


  }


}