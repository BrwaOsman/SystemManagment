// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unnecessary_new, non_constant_identifier_names, sized_box_for_whitespace, avoid_unnecessary_containers, deprecated_member_use, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:systemmangemynt/model/product.dart';
import 'package:systemmangemynt/page/Edit_Product.dart';
import 'package:systemmangemynt/server/_firestor.dart';

class ListOfProduct extends StatefulWidget {
  const ListOfProduct({Key? key}) : super(key: key);

  @override
  _ListOfProductState createState() => _ListOfProductState();
}

class _ListOfProductState extends State<ListOfProduct> {
  TextEditingController _searchProduct = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ScrollController _scrollController = new ScrollController();

  DateTime? Fdate;
  String? _getDataSearch;
  bool _iconSearch = false;
  FireStor _fireStor = FireStor();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Of Product"),
        centerTitle: true,
        backgroundColor: Colors.grey[400],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 20, 167, 162),
        child: const Icon(
          Icons.add_shopping_cart,
          size: 40,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/addProduct");
        },
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  onChanged: (value) {
                    if (value.length < 1) {
                      setState(() {
                        _getDataSearch = null;
                        _iconSearch = false;
                      });
                    } else {
                      setState(() {
                        _getDataSearch = value;
                        _iconSearch = true;
                      });
                    }
                  },
                  style: TextStyle(color: Colors.grey),
                  controller: _searchProduct,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: null,
                    label: Text("Search"),
                  ),
                ),
              )),
              IconButton(
                  onPressed: _iconSearch == false
                      ? null
                      : () {
                          setState(() {
                            _getDataSearch = _searchProduct.value.text;
                          });
                        },
                  icon: Icon(Icons.search))
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            // stream: _firestore.collection('product').snapshots(),
            stream: _fireStor.getDataUser(_getDataSearch),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                List<DocumentSnapshot> _docs = snapshot.data!.docs;
                if (_scrollController.hasClients) {
                  _scrollController
                      .jumpTo(_scrollController.position.minScrollExtent);
                }
                List<Product> _product = _docs
                    .map((e) =>
                        Product.fromMap(e.data() as Map<String, dynamic>))
                    .toList();

                return Expanded(
                  child: ListView.builder(
                      reverse: false,
                      // shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: _product.length,
                      itemBuilder: (context, index) {
                        return show_product(_product, index, _docs);
                      }),
                );
              }
              return Center(
                child: Text("Empty"),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Navigator.pushNamed(context, '/export');
              },
            ),
          ],
        ),
      ),
    );
  }

  date(Timestamp timestamp) {
    Fdate = timestamp.toDate();
    return "${Fdate!.day}/${Fdate!.month}/${Fdate!.year}";
  }

  show_delet(int index, List<DocumentSnapshot> _docs) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 200,
            height: 150,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Positioned(
                        left: 100,
                        child: InkResponse(
                          child: CircleAvatar(
                            child: Center(
                                child: Icon(
                              Icons.delete,
                              size: 40,
                              color: Colors.red,
                            )),
                            backgroundColor: Colors.white,
                          ),
                        )),
                  ),
                  Center(
                    child: Text("Are you sure you have delete it ?"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          _firestore
                              .collection("product")
                              .doc(_docs[index].id)
                              .delete();
                          Navigator.of(context).pop();
                        },
                        child: Text("Delete"),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancle"))),
                    ],
                  )
                ]),
          ),
        );
      },
    );
  }

  show(List<Product> product, int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.remove_red_eye,
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("250 views"),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text_dialog(
                        context, "barcode: ", "${product[index].barcode}"),
                    text_dialog(
                        context, "Category: ", "${product[index].category}"),
                    text_dialog(
                        context, "Product name: ", "${product[index].name}"),
                    text_dialog(
                        context, "Product Desc: ", "${product[index].desc}"),
                    text_dialog(
                        context, "product_cost: ", "${product[index].cost}"),
                    text_dialog(
                        context, "quantity: ", "${product[index].quantity}"),
                    text_dialog(
                        context, "product_price: ", "${product[index].price}"),
                    text_dialog(context, "manufacturing_data: ",
                        "${date(product[index].date!)}"),
                    text_dialog(context, "expiration_date: ",
                        "${date(product[index].expiration!)}"),
                  ],
                )
              ],
            ),
          );
        });
  }

  RichText text_dialog(BuildContext context, String fname, String lname) {
    return RichText(
      text: TextSpan(
        text: fname,
        style: TextStyle(fontSize: 16, color: Colors.black),
        children: <TextSpan>[
          TextSpan(
              text: lname,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  show_product(List<Product> product, int index, List<DocumentSnapshot> _docs) {
    return InkWell(
      onTap: () {
        show(product, index);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(10),
        color: Colors.grey[300],
        child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            actions: [
              IconSlideAction(
                caption: 'Delete',
                color: Colors.grey[300],
                icon: Icons.delete,
                onTap: () {
                  show_delet(index, _docs);
                },
              )
            ],
            secondaryActions: [
              IconSlideAction(
                caption: 'Edit',
                color: Colors.grey[300],
                icon: Icons.edit,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EidtProduct(
                  id:_docs[index].id,
                  barcode:product[index].barcode,
                  category:product[index].category,
                  name:product[index].name,
                  desc:product[index].desc,
                  quantity:product[index].quantity,
                  cost:product[index].cost,
                  price:product[index].price,
                  date:product[index].date,
                  expiration:product[index].expiration,
                  image:product[index].image,


                ),)),
              )
            ],
            child: Row(
              children: [
                Container(
                  width: 60,
                  child: Image.network(
               product[index].image ==null? "https://media.istockphoto.com/photos/red-wine-with-barrel-on-vineyard-in-green-tuscany-italy-picture-id1146711814?b=1&k=20&m=1146711814&s=170667a&w=0&h=wjDeHHxMW8wUiTSxqnw-fkUteCVqGoIt-MKSUIftVrg="
               :product[index].image!,
                    width: 60,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text("${product[index].name}"),
                      Text("${product[index].category}"),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(product[index].quantity.toString()),
                )
              ],
            )),
      ),
    );
  }
}
