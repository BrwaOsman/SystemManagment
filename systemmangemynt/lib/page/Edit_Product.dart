// ignore_for_file: prefer_const_constructors, prefer_final_fields, curly_braces_in_flow_control_structures, non_constant_identifier_names, avoid_print, unused_element, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:systemmangemynt/model/product.dart';

import '../server/_firestor.dart';

class EidtProduct extends StatefulWidget {
  final String id;
  final String? barcode;
  final String? category;
  final String? name;
  final String? desc;
  final int? quantity;
  final int? cost;
  final int? price;
  final Timestamp? date;
  final Timestamp? expiration;
  final String? image;
  const EidtProduct(
      {Key? key,
      required this.id,
      this.barcode,
      this.category,
      this.cost,
      this.date,
      this.desc,
      this.expiration,
      this.image,
      this.name,
      this.price,
      this.quantity})
      : super(key: key);

  @override
  _EidtProductState createState() => _EidtProductState();
}

class _EidtProductState extends State<EidtProduct> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _barcode = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  TextEditingController _cost = TextEditingController();
  TextEditingController _price = TextEditingController();

  FireStor _stor = FireStor();
  File? imageFile;
  String? ImageUrl;
  bool img = false;
  bool _loading = false;
  String? _category;

// change dateTime to timestamp
  date(Timestamp timestamp, DateTime? Fdate) {
    Fdate = timestamp.toDate();
    return "${Fdate.day}/${Fdate.month}/${Fdate.year}";
  }

  date2(Timestamp timestamp, DateTime? Fdate) {
    Fdate = timestamp.toDate();
    return Fdate;
  }

//  date Time
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
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _stor.ImageUrl = null;
   _barcode.text = widget.barcode!;
    _name.text = widget.name!;
    _desc.text = widget.desc!;
    _quantity.text = "${widget.quantity}";
    _cost.text = "${widget.cost}";
    _price.text = "${widget.price}";

    });
  }

  @override
  Widget build(BuildContext context) {
 

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Prodouct"),
        centerTitle: true,
      ),
      body: Form(
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                    child:
                        TextFormFild("barcode", _barcode, 0, widget.barcode!)),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.qr_code,
                    size: 50,
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
                  "${widget.category}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _category = value;
                    print(_category);
                  });
                },
                // onChanged: (String value) {

                // },
              ),
            ),
            TextFormFild("product_name", _name, 0, widget.name!),
            TextFormFild("product_desc", _desc, 0, widget.desc!),
            TextFormFild(
                "product_quantity", _quantity, 1, "${widget.quantity}"),
            TextFormFild("product_cost", _cost, 1, "${widget.cost}"),
            TextFormFild("product_price", _price, 1, "${widget.price}"),
            text_Icons(1, currentDate, widget.date!),
            text_Icons(0, exp_date, widget.expiration!),
            InkWell(
              onTap: () {
                _stor.getImage(imageFile);
            
                setState(() {
                  img = true;
                });
        
                
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
                  "${widget.image}" ,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: () async {
                    if (_loading) return;
                    setState(() => _loading = true);
                    await Future.delayed(Duration(seconds: 5));
                    setState(() => _loading = false);
                    Edit_data();
                    print(_stor.ImageUrl);
                    Navigator.pushNamed(context, '/');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 39, 191, 181)),
                  child: _loading == true
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 24,
                            ),
                            Text('Please waie ...')
                          ],
                        )
                      : Text(
                          "Edit Product",
                          style: TextStyle(color: Colors.white),
                        )),
            )
          ],
        ),
      ),
    );
  }

  text_Icons(int x, DateTime dateTime, Timestamp _times) {
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
                date(_times, dateTime),
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

  Container TextFormFild(
      String name, TextEditingController controller, int x, String con) {
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
          onChanged: (value) {
            con = value;
          },
        ),
      ),
    );
  }

  Future Edit_data() async {
    Product _product = Product(
        barcode: _barcode.value.text,
        name: _name.value.text,
        category: _category == null ? widget.category: _category,
        desc: _desc.value.text,
        quantity: int.parse(_quantity.value.text),
        cost: int.parse(_cost.value.text),
        price: int.parse(_price.value.text),
        date: Timestamp.fromDate(date2(widget.date!, currentDate)),
        expiration: Timestamp.fromDate(date2(widget.expiration!, exp_date)),
        image: img == false ? widget.image : _stor.ImageUrl);
    await _firestore
        .collection("product")
        .doc(widget.id)
        .update(_product.toMap());
  }
}
