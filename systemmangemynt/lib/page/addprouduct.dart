// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_final_fields, non_constant_identifier_names, unnecessary_string_interpolations, curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:systemmangemynt/model/product.dart';
import 'package:systemmangemynt/server/_firestor.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AddProudct extends StatefulWidget {
  const AddProudct({Key? key}) : super(key: key);

  @override
  _AddProudctState createState() => _AddProudctState();
}

class _AddProudctState extends State<AddProudct> {
  String? _category;
  String? barcode = '';
  //TextEditingController _bardoe = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  TextEditingController _cost = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _date = TextEditingController();
  TextEditingController _exp = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FireStor _stor = FireStor();
  File? imageFile;
  String? ImageUrl;
  bool img = false;

// date Time
  DateTime currentDate = DateTime.now();
  DateTime exp_date = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1990),
        lastDate: DateTime(2200));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
  }

  Future<void> _selectDateExp(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: exp_date,
        firstDate: DateTime(1990),
        lastDate: DateTime(2200));
    if (pickedDate != null && pickedDate != exp_date)
      setState(() {
        exp_date = pickedDate;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a New Product"),
        centerTitle: true,
        backgroundColor: Colors.grey[400],
      ),
      body: Form(
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(hintText: barcode),
                )),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    onPressed: () async {
                      String barcodeScanRes =
                          await FlutterBarcodeScanner.scanBarcode(
                              "#ff6666", "Cancel", false, ScanMode.DEFAULT);
                      print('=============> ${barcodeScanRes}');
                      setState(() {
                        barcode = barcodeScanRes;
                      });
                    },
                    icon: Icon(Icons.qr_code),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              color: Colors.grey[200],
              child: DropdownButton(
                focusColor: Colors.grey[200],
                value: _category,
                elevation: 5,
                style: TextStyle(color: Colors.grey[200]),
                iconEnabledColor: Colors.black,
                items: <String>[
                  'Android',
                  'IOS',
                  'Flutter',
                  'Node',
                  'Java',
                  'Python',
                  'PHP',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                hint: Text(
                  "Category",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _category = value;
                  });
                },
                // onChanged: (String value) {

                // },
              ),
            ),
            TextFormFild("product_name", _name, 0),
            TextFormFild("product_desc", _desc, 0),
            TextFormFild("product_quantity", _quantity, 1),
            TextFormFild("product_cost", _cost, 1),
            TextFormFild("product_price", _price, 1),
            text_Icons(1, currentDate),
            text_Icons(0, exp_date),
            InkWell(
              onTap: () {
                _stor.getImage(imageFile);
                if (_stor.ImageUrl != null) {
                  setState(() {
                    img = true;
                  });
                }
              },
              child: Container(
                // padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(15)),
                child: Image.network(
                  img == false
                      ? "https://images.unsplash.com/photo-1599420186946-7b6fb4e297f0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHw2fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60"
                      : _stor.ImageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: () {
                    add_data();
                    print(_stor.ImageUrl);
                    Navigator.pushNamed(context, '/');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 39, 191, 181)),
                  child: Text(
                    "Add Product",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

  text_Icons(int x, DateTime dateTime) {
    return InkWell(
      onTap: () {
        x == 1 ? _selectDate(context) : _selectDateExp(context);
      },
      child: Container(
        child: Row(
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Text(
                "${dateTime.day}-${dateTime.month}-${dateTime.year}",
                style: TextStyle(fontSize: 18),
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.date_range,
                size: 50,
              ),
            )
          ],
        ),
      ),
    );
  }

  Container TextFormFild(String name, TextEditingController controller, int x) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          keyboardType: x == 1 ? TextInputType.number : null,
          controller: controller,
          decoration: InputDecoration(
              label: Text("$name"),
              fillColor: Colors.grey[200],
              filled: true,
              border: InputBorder.none),
        ),
      ),
    );
  }

  Future add_data() async {
    Product _product = Product(
        barcode: barcode,
        name: _name.value.text,
        category: _category,
        desc: _desc.value.text,
        quantity: int.parse(_quantity.value.text),
        cost: int.parse(_cost.value.text),
        price: int.parse(_price.value.text),
        date: Timestamp.fromDate(currentDate),
        expiration: Timestamp.fromDate(exp_date),
        image: _stor.ImageUrl);
    await _firestore.collection("product").add(_product.toMap());
  }
}
