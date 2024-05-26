import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _productCodeTEController =
      TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewProductInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameTEController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    labelText: 'Name',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _productCodeTEController,
                  decoration: const InputDecoration(
                    hintText: 'Product Code',
                    labelText: 'Product Code',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your product code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _unitPriceTEController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Unit Price',
                    labelText: 'Unit Price',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your unit price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityTEController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Quantity',
                    labelText: 'Quantity',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _totalPriceTEController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Total Price',
                    labelText: 'Total Price',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your total price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageTEController,
                  decoration: const InputDecoration(
                    hintText: 'Image',
                    labelText: 'Image',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your image link';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: _addNewProductInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addProduct();
                      }
                    },
                    child: const Text(
                      'Add',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addProduct() async {
    _addNewProductInProgress = true;
    setState(() {});

    const String addNewProductUrl =
        'https://crud.teamrabbil.com/api/v1/CreateProduct';

    Map<String, dynamic> inputData = {
      "Ing": _imageTEController.text.trim(),
      "ProductCode": _productCodeTEController.text,
      "ProductName": _nameTEController.text,
      "Qty": _quantityTEController.text,
      "TotalPrice": _totalPriceTEController.text,
      "UnitPrice": _unitPriceTEController.text
    };

    Uri uri = Uri.parse(addNewProductUrl);
    Response response = await post(
      uri,
      body: jsonEncode(inputData),
      headers: {'content-type': 'application/json'},
    );

    _addNewProductInProgress = false;
    setState(() {});

    if (response.statusCode == 200) {
      _nameTEController.clear();
      _productCodeTEController.clear();
      _unitPriceTEController.clear();
      _quantityTEController.clear();
      _totalPriceTEController.clear();
      _imageTEController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('New product added'), backgroundColor: Colors.green,));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New product failed! Try again!!')));
    }
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _unitPriceTEController.dispose();
    _quantityTEController.dispose();
    _totalPriceTEController.dispose();
    _imageTEController.dispose();
    super.dispose();
  }
}
