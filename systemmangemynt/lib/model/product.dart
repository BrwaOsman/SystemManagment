// import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? barcode;
  String? category;
  String? name;
  String? desc;
  int? quantity;
  int? cost;
  int? price;
  Timestamp? date;
  Timestamp? expiration;
  String? image;
  Product(
      {this.barcode,
      this.category,
      this.cost,
      this.date,
      this.desc,
      this.expiration,
      this.image,
      this.name,
      this.price,
      this.quantity});

  factory Product.fromMap(map) {
    return Product(
      barcode: map['barcode'],
      name: map['name'],
      category: map['category'],
      cost: map['cost'],
      date: map['date'],
      desc: map['desc'],
      expiration: map['expiration'],
      image: map['image'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'name': name,
      'category': category,
      'desc':desc,
      'cost': cost,
      'date': date,
      'expiration': expiration,
      'image': image,
      'price': price,
      'quantity': quantity
    };
  }
}
