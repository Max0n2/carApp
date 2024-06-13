import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inforce/modals/deleteConfirmation.dart';
import 'package:inforce/models/car.dart';
import 'package:inforce/provider/carProvider.dart';
import 'package:provider/provider.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final carProvider = Provider.of<CarProvider>(context);
    final _makeController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          flexibleSpace: SafeArea(
            child: Container(
              color: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _makeController,
                          decoration: InputDecoration(
                            hintText: 'Enter make',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if(_makeController.text.isNotEmpty) {
                            carProvider.addCarToList(_makeController.text);
                          } else {

                          }
                        },
                        icon: Icon(CupertinoIcons.right_chevron),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  DropdownButton(
                    value: carProvider.selectedSortType,
                    elevation: 16,
                    onChanged: (newValue) {
                      carProvider.updateSortType(newValue);
                      carProvider.getCars();
                    },
                    items: carProvider.sortTypes.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 12,
              child: FutureBuilder<List<CarModel>>(
                future:
                    carProvider.carsList.isEmpty ? carProvider.getCars() : null,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  } else if (snapshot.hasData == null) {
                    return Center(child: Text("Error data not found"));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: carProvider.carsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      '${index + 1}.${carProvider.carsList[index].make}'),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ModalDeleteConfirmation(
                                                make: carProvider
                                                    .carsList[index].make,
                                                index: index,
                                              );
                                            });
                                      },
                                      icon: Icon(CupertinoIcons.trash))
                                ],
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
