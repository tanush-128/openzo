import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/address.dart';
import 'package:openzo_frontend/repositories/address_repository.dart';
import 'package:openzo_frontend/viewmodels/user_provider.dart';

class AddressViewModel extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  UserProvider userProvider;
  AddressViewModel(this.userProvider);
  String? _selectedAddressId;
  String get selectedAddressId => _selectedAddressId ?? '';

  void initialize(Address? address) {
    if (address != null) {
      _selectedAddressId = address.id;
      phoneController.text = address.phoneNo;
      areaController.text = address.area;
      buildingController.text = address.building;
      landmarkController.text = address.nearbyLandmark;
    } else {
      phoneController.text = userProvider.user?.phone ?? '';
    }
  }

  Future<void> saveAddress() async {
    // Logic to save the address to the backend or a database
    log('Address saved, phone: ${phoneController.text}, area: ${areaController.text}, building: ${buildingController.text}, landmark: ${landmarkController.text}');
    Address address = Address(
      userId: userProvider.user!.id,
      pincode: userProvider.user!.pincode ?? '123456',
      phoneNo: phoneController.text,
      area: areaController.text,
      building: buildingController.text,
      nearbyLandmark: landmarkController.text,
    );
    //create or update address
    if (selectedAddressId.isEmpty) {
      final newAddress = await AddressRepository.createAddress(address);
      userProvider.setAddresses([...userProvider.addresses, newAddress]);
    } else {
      address.id = selectedAddressId;
      final updatedAddress = await AddressRepository.updateAddress(address);
      userProvider.setAddresses(userProvider.addresses
          .map((address) =>
              address.id == selectedAddressId ? updatedAddress : address)
          .toList());
    }
    // notifyListeners();
  }

  void clear() {
    phoneController.clear();
    areaController.clear();
    buildingController.clear();
    landmarkController.clear();
    _selectedAddressId = null;
    notifyListeners();
  }
}
