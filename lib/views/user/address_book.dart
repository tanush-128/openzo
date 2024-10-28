import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/address.dart';
import 'package:openzo_frontend/viewmodels/user_provider.dart';
import 'package:openzo_frontend/views/user/widgets/address_bottom_sheet.dart';
import 'package:provider/provider.dart';

class AddressListViewPage extends StatelessWidget {
  const AddressListViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Addresses'),
      ),
      body: AddressListView(),
    );
  }
}

class AddressListView extends StatelessWidget {
  bool selectindAddress = false;
  AddressListView({
    super.key,
    this.selectindAddress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                editSheet(context, null);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.add),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add new',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Save a address for future use',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.grey.shade100,
              height: 10,
              width: double.infinity,
            ),
            ListView(
              shrinkWrap: true,
              children: userProvider.addresses
                  .map((address) => InkWell(
                        child: AddressListTile(address: address),
                        onTap: () {
                          if (selectindAddress) {
                            log('Selected address: $address');
                            Navigator.pop(context, address);
                          }
                        },
                      ))
                  .toList(),
            )
          ],
        );
      },
    );
  }
}

class AddressListTile extends StatelessWidget {
  Address address;
  AddressListTile({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        // color: Colors.grey.shade100,
        // borderRadius: BorderRadius.circular(8),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.shade300,
        //     blurRadius: 5,
        //     offset: const Offset(0, 2),
        //   ),
        // ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.home_rounded),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${address.building}, ${address.area}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Text(address.nearbyLandmark),
              Row(
                children: [
                  Text("Phone number : ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      )),
                  Text(address.phoneNo),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      editSheet(context, address);
                    },
                    child: const Text('Edit',
                        style: TextStyle(
                          color: GlobalStyle.primaryColor,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      // editSheet(context, address);
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
