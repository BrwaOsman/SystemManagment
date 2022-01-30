import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class FireStor {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getDataUser(String? name) {
    if (name != null) {
      return _fireStore
          .collection("product")
          .where('name', isEqualTo: name)
          // .where('barcode', isEqualTo: barcode)
          .snapshots();
    } else {
      return _fireStore.collection("product").snapshots();
    }
  }

  String? ImageUrl = null;
  Future getImage(File? imageFile) async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
     
          imageFile = File(xFile.path);
          uploadImage(imageFile);
     
      }
    });
  }

  Future uploadImage(File? imageFile) async {
    String fileName = Uuid().v1();

    if (ImageUrl == null) {
      var ref =
          FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");
      var uploadTask = await ref.putFile(imageFile!);

      ImageUrl = await uploadTask.ref.getDownloadURL();
    }

    print(ImageUrl);
  }
}
