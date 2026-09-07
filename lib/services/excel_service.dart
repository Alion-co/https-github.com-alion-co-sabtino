import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../location_model.dart';



class ExcelService {


  static Future<void> exportLocations(

      List<LocationData> locations

      ) async {



    final excel = Excel.createExcel();


    final sheet = excel['Sheet1'];



    sheet.appendRow([

      TextCellValue("نام"),

      TextCellValue("آدرس"),

      TextCellValue("شماره تماس"),

    ]);





    for (var item in locations) {


      sheet.appendRow([


        TextCellValue(item.name),


        TextCellValue(item.address),


        TextCellValue(item.phone),


      ]);


    }






    final directory =

    await getTemporaryDirectory();




    final path =

        "${directory.path}/Sabtino_Export.xlsx";





    final bytes = excel.save();



    if(bytes == null){

      return;

    }





    final file = File(path);



    await file.writeAsBytes(

      bytes,

      flush: true,

    );






    await Share.shareXFiles(

      [

        XFile(file.path),

      ],


      text:

      "خروجی",

    );


  }


}