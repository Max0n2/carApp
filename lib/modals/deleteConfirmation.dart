import 'package:flutter/material.dart';
import 'package:inforce/provider/carProvider.dart';
import 'package:provider/provider.dart';

class ModalDeleteConfirmation extends StatelessWidget {
  const ModalDeleteConfirmation(
      {super.key, required this.make, required this.index});

  final String make;
  final int index;

  @override
  Widget build(BuildContext context) {
    final cars = Provider.of<CarProvider>(context);

    return AlertDialog(
      title: Text("You sure you whant delete ${make}?"),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel")),
        ElevatedButton(
            onPressed: () {
              cars.removeCarFromList(index);
              Navigator.pop(context);
            },
            child: Text("Confirm"))
      ],
    );
  }
}
