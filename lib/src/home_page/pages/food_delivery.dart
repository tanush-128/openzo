import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/home_page/widgets/stores_list.dart';

class FoodDelivery extends StatelessWidget {
  const FoodDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Delivery"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            StoresList(
                future: Store.getStoreByPincodeAndCategory("123456", "Food"))
          ]),
        ),
      ),
    );
  }
}
