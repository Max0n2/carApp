import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inforce/models/car.dart';

class CarProvider extends ChangeNotifier {
  String url = "https://freetestapi.com";
  List<CarModel> carsList = [];
  var sortTypes = ['No sort','Alphabet', 'Count'];
  late Object? selectedSortType = 'No sort';

  void updateSortType(Object? selectedType) {
    selectedSortType = selectedType;
    notifyListeners();
  }

  void addCarToList(String make) {
    carsList.add(CarModel(make: make));
    notifyListeners();
  }

  void removeCarFromList(int index) {
    carsList.removeAt(index);
    notifyListeners();
  }

  Future<List<CarModel>> getCars() async {
    final dio = Dio();

    try {
      if (carsList.isEmpty) {
        final response = await dio.get('${url}/api/v1/cars');
        carsList.addAll(parseCars(response));
      }

      if (selectedSortType == 'Alphabet') {
        carsList.sort((a, b) => a.make.compareTo(b.make));
      } else if (selectedSortType == 'Count') {
        carsList.sort((a, b) {
          int countA = carsList.where((car) => car.make == a.make).length;
          int countB = carsList.where((car) => car.make == b.make).length;

          int countComparison = countB.compareTo(countA);
          notifyListeners();
          if (countComparison != 0) {
            return countComparison;
          } else {
            return a.make.compareTo(b.make);
          }
        });
      }

      notifyListeners();
      return carsList;
    } catch (e) {
      print(e);
      return [];
    }
  }


  List<CarModel> parseCars(dynamic response) {
    final results = List<Map<String, dynamic>>.from(response.data);
    List<CarModel> cars = results
        .map((carData) => CarModel.fromJson(carData))
        .toList(growable: false);
    return cars;
  }
}
