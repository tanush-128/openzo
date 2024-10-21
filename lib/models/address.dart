// type Address struct {
// 	ID             string `gorm:"primaryKey" json:"id"`
// 	UserId         string `json:"user_id"`
// 	Name           string `json:"name"`
// 	Tag            string `json:"tag"`
// 	Area           string `json:"area"`
// 	Building       string `json:"building"`
// 	NearbyLandmark string `json:"nearby_landmark"`
// 	Address        string `json:"address"`
// 	Pincode        string `json:"pincode"`
// 	City           string `json:"city"`
// 	State          string `json:"state"`
// 	Latitude       string `json:"latitude"`
// 	Longitude      string `json:"longitude"`
// }

class Address {
  String id;
  String userId;
  String name;
  String tag;
  String area;
  String building;
  String nearbyLandmark;
  String address;
  String pincode;
  String city;
  String state;
  String latitude;
  String longitude;
  String phoneNo;

  Address({
    this.id = "",
    required this.userId,
    this.name = "",
    this.tag = "",
    this.area = "",
    this.building = "",
    this.nearbyLandmark = "",
    this.address = "",
    required this.pincode,
    this.city = "",
    this.state = "",
    this.latitude = "",
    this.longitude = "",
    required this.phoneNo,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      tag: json['tag'],
      area: json['area'],
      building: json['building'],
      nearbyLandmark: json['nearby_landmark'],
      address: json['address'],
      pincode: json['pincode'],
      city: json['city'],
      state: json['state'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      phoneNo: json['phone_no'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'tag': tag,
      'area': area,
      'building': building,
      'nearby_landmark': nearbyLandmark,
      'address': address,
      'pincode': pincode,
      'city': city,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
      'phone_no': phoneNo,
    };
  }
}
