class CarModel {
  String make;

  CarModel({
    required this.make,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      make: json['make'],
    );
  }
}
