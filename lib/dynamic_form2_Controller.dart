import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:nested_dropdown/dynamic_form2_model.dart';

class DynamicForm2Controller extends GetxController {
  List<brandsModel> brandData = [];
  List<MultiSelectItem> dropdowndata = [];
  List<String> selectedBrandIds = []; // Store the selected brand IDs
  List<SkuModel> skuData = []; 
  List<SkuModel> filteredSkuData = []; 
  List<SkuWithQuantity> selectedSkusWithQuantity = [];
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final locationController = TextEditingController();
  final quantityController = TextEditingController();

  Map<String, List<SkuModel>> brandSkuMap = {
    "1": [
      SkuModel(skuId: "1", skuName: "Day Dream | Rs.30"),
      SkuModel(skuId: "2", skuName: "Day Dream | Rs.200"),
    ],
    "2": [
      SkuModel(skuId: "3", skuName: "Mi Amor | Rs.40"),
      SkuModel(skuId: "4", skuName: "Mi Amor | Rs.250"),
    ],
    "3": [
      SkuModel(skuId: "5", skuName: "Chip Hop | Rs.30"),
      SkuModel(skuId: "6", skuName: "Chip Hop | Rs.200"),
    ],
    "4": [
      SkuModel(skuId: "7", skuName: "Chip Hop | Rs.200"),
    ],
    "5": [
      SkuModel(skuId: "8", skuName: "Eclipse | Rs.30"),
      SkuModel(skuId: "9", skuName: "Eclipse | Rs.200"),
    ],
    "6": [
      SkuModel(skuId: "10", skuName: "Divine | Rs.30"),
      SkuModel(skuId: "11", skuName: "Divine | Rs.250"),
    ],
    "7": [
      SkuModel(skuId: "12", skuName: "Butter Cookies | Rs.70"),
    ],
    "8": [
      SkuModel(skuId: "13", skuName: "Delice | Rs.30"),
    ],
  };

  getSkuData(List<String> selectedBrandIds) {
    filteredSkuData.clear();

    selectedBrandIds.forEach((brandId) {
      if (brandSkuMap.containsKey(brandId)) {
        filteredSkuData.addAll(brandSkuMap[brandId]!);
      }
    });

    update(); 
  }

  getBrandData() {
    brandData.clear();
    dropdowndata.clear();

    Map<String, dynamic> apiResponse = {
      "code": 200,
      "message": "Brands List",
      "data": [
        {"brand_id": "1", "brand_name": "Day Dream"},
        {"brand_id": "2", "brand_name": "Mi Amor"},
        {"brand_id": "3", "brand_name": "Chip Hop Chocolate"},
        {"brand_id": "4", "brand_name": "Chip Hop Vanilla"},
        {"brand_id": "5", "brand_name": "Eclipse"},
        {"brand_id": "6", "brand_name": "Divine"},
        {"brand_id": "7", "brand_name": "Butter Cookies"},
        {"brand_id": "8", "brand_name": "Delice"},
      ]
    };

    if (apiResponse['code'] == 200) {
      List<brandsModel> tempBrandData = [];
      apiResponse['data'].forEach((data) {
        tempBrandData.add(brandsModel(
            brandId: data['brand_id'], brandName: data['brand_name']));
      });

      brandData.addAll(tempBrandData);

      dropdowndata = brandData.map((brandData) {
        return MultiSelectItem(brandData, brandData.brandName);
      }).toList();

      update();
    } else {
      print('Show some error model like something went wrong..');
    }
  }

  updateSelectedBrands(List<String> selectedIds) {
    selectedBrandIds = selectedIds;
    getSkuData(selectedBrandIds); // Fetch SKU data based on selected brands
    update(); 
  }

  void updateSelectedSkusWithQuantity(List<SkuModel> selectedSkus) {
    selectedSkusWithQuantity.clear();
    selectedSkus.forEach((sku) {
      selectedSkusWithQuantity.add(SkuWithQuantity(
        skuId: sku.skuId,
        skuName: sku.skuName,
        quantityController: TextEditingController(),
      ));

       selectedSkusWithQuantity.remove(SkuWithQuantity(
        skuId: sku.skuId,
        skuName: sku.skuName,
        quantityController: TextEditingController(),
      ));
    });
    update();
  }

  
  Map<String, int> getSkuQuantities() {
    Map<String, int> skuQuantities = {};
    for (var skuWithQuantity in selectedSkusWithQuantity) {
      int quantity = int.tryParse(skuWithQuantity.quantityController.text) ?? 0;
      skuQuantities[skuWithQuantity.skuId] = quantity;
    }
    return skuQuantities;
  }

  Future<void> getLocation() async {
   
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      
      print('Location services are disabled.');
      return;
    }

    
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return;
      }
    }

    
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('Current location: ${position.latitude}, ${position.longitude}');

    
    locationController.text =
        '${position.latitude}, ${position.longitude}';
  }

  
  Future<void> onSubmit() async {
    String name = nameController.text;
    String mobile = mobileController.text;
    String location = locationController.text;
    Map<String, int> skuQuantities = getSkuQuantities();

    
    Map<String, dynamic> data = {
      "name": name,
      "mobile": mobile,
      "location": location,
      "brand_names": selectedBrandIds,
      "skus": skuQuantities
    };

    
    String url = 'https://your-api-endpoint.com/submit';

    try {
     
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Data submitted successfully');
        
      } else {
        print('Failed to submit data');
        
      }
    } catch (e) {
      print('Error: $e');
      
    }
  }
}
