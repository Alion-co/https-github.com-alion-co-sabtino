import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class MapCard extends StatelessWidget {

  final MapController controller;

  final LatLng position;

  final Function(LatLng)? onTap;


  const MapCard({

    super.key,

    required this.controller,

    required this.position,

    this.onTap,

  });



  @override
  Widget build(BuildContext context) {


    return Container(

      height:280,


      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(22),


        boxShadow:[

          BoxShadow(

            color:
            Colors.black.withOpacity(.07),

            blurRadius:22,

            offset:
            const Offset(0,8),

          )

        ],

      ),


      clipBehavior: Clip.antiAlias,


      child: FlutterMap(

        mapController: controller,


        options: MapOptions(

          initialCenter: position,

          initialZoom:14,


          onTap: (_, point){

            if(onTap != null){

              onTap!(point);

            }

          },


        ),



        children:[


          TileLayer(

            urlTemplate:

            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",


            userAgentPackageName:

            "ir.sabtino.app",

          ),




          MarkerLayer(

            markers:[


              Marker(

                point:position,


                child:const Icon(

                  Icons.location_on_rounded,

                  size:45,

                  color:Colors.red,

                ),

              )


            ],

          )


        ],

      ),


    );


  }


}
