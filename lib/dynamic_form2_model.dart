import 'package:flutter/material.dart';

class brandsModel{
  String brandName;
  String brandId;
  brandsModel({
    required this.brandId,
    required this.brandName
  });
}

class SkuModel {
  String skuId;
  String skuName;

  SkuModel({
    required this.skuId,
    required this.skuName,
  });
}
class SkuWithQuantity {
  final String skuId;
  final String skuName;
  final TextEditingController quantityController;

  SkuWithQuantity({
    required this.skuId,
    required this.skuName,
    required this.quantityController,
  });
}

