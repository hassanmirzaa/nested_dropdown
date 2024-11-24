import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:nested_dropdown/dynamic_form2_Controller.dart';
import 'package:nested_dropdown/dynamic_form2_model.dart';

class DynamicForm2Screen extends StatefulWidget {
  const DynamicForm2Screen({super.key});

  @override
  State<DynamicForm2Screen> createState() => _DynamicForm2ScreenState();
}

class _DynamicForm2ScreenState extends State<DynamicForm2Screen> {
  final DynamicForm2Controller controller = Get.put(DynamicForm2Controller());

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getBrandData();
    });

    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Multi Select Dropdown'),
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: TextField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Mobile No#',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: TextField(
                    controller: controller.mobileController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your Mobile No#',
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.getLocation,
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: TextField(
                    controller: controller.locationController,
                    decoration: const InputDecoration(
                      hintText: 'Getting your location...',
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                    ),
                    keyboardType: TextInputType.text,
                    readOnly: true,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Brands :',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GetBuilder<DynamicForm2Controller>(
                builder: (controller) {
                  return MultiSelectDialogField(
                    dialogHeight: 200,
                    items: controller.dropdowndata,
                    initialValue: controller.selectedBrandIds
                        .map((id) => controller.brandData.firstWhere(
                            (brand) => brand.brandId == id,
                            orElse: () => brandsModel(
                                brandId: '',
                                brandName:
                                    '') // Provide a default empty brand model
                            ))
                        .where((brand) => brand.brandId
                            .isNotEmpty) // Filter out the empty brand models
                        .toList(),
                    title: const Text(
                      'Select Brands',
                      style: TextStyle(color: Colors.black),
                    ),
                    selectedColor: Colors.black,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    buttonIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    buttonText: const Text(
                      'Select Your Brands',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onConfirm: (results) {
                      List<String> brandIds = [];
                      for (var i = 0; i < results.length; i++) {
                        brandsModel data = results[i] as brandsModel;
                        brandIds.add(data.brandId);
                      }
                      controller.updateSelectedBrands(brandIds);
                    },
                  );
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'SKUs :',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GetBuilder<DynamicForm2Controller>(
                builder: (controller) {
                  return MultiSelectDialogField(
                    dialogHeight: 200,
                    items: controller.filteredSkuData.map((sku) {
                      return MultiSelectItem(sku, sku.skuName);
                    }).toList(),
                    title: const Text(
                      'Select SKUs',
                      style: TextStyle(color: Colors.black),
                    ),
                    selectedColor: Colors.black,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    buttonIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    buttonText: const Text(
                      'Select Your SKUs',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onConfirm: (results) {
                      List<SkuModel> skuData = [];
                      for (var i = 0; i < results.length; i++) {
                        SkuModel data = results[i] as SkuModel;
                        skuData.add(data);
                      }
                      controller.updateSelectedSkusWithQuantity(skuData);
                    },
                  );
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              GetBuilder<DynamicForm2Controller>(
                builder: (controller) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.selectedSkusWithQuantity
                        .map((skuWithQuantity) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  skuWithQuantity.skuName,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  controller:
                                      skuWithQuantity.quantityController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: "Qty",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 14.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Center(
                child: GestureDetector(
                  onTap: _isLoading ? null : controller.onSubmit,
                  
                 
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.3,
                    height: MediaQuery.of(context).size.width*0.1,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Submit',
                          style: TextStyle(
                            fontSize: 20
                          ),
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
