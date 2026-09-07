// lib/location_model.dart

class LocationData {

  final int? id;

  final String name;
  final String address;
  final String phone;

  final double latitude;
  final double longitude;


  LocationData({

    this.id,

    required this.name,
    required this.address,
    required this.phone,

    required this.latitude,
    required this.longitude,

  });



  Map<String, dynamic> toMap() {

    return {

      if (id != null)
        "id": id,

      "name": name,

      "address": address,

      "phone": phone,

      "latitude": latitude,

      "longitude": longitude,

    };

  }



  factory LocationData.fromMap(Map<String, dynamic> map) {

    return LocationData(

      id: map["id"],

      name: map["name"] ?? "",

      address: map["address"] ?? "",

      phone: map["phone"] ?? "",

      latitude: map["latitude"] ?? 0.0,

      longitude: map["longitude"] ?? 0.0,

    );

  }

}