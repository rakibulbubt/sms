import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddNewCourse extends StatefulWidget {
  const AddNewCourse({Key? key}) : super(key: key);

  @override
  State<AddNewCourse> createState() => _AddNewCourseState();
}

class _AddNewCourseState extends State<AddNewCourse> {
  TextEditingController _courseNameController = TextEditingController();
  TextEditingController _courseFeeController = TextEditingController();

  XFile? _courseImage;
  String? _imageURL;

  chooseImageFromGC() async {
    ImagePicker _picker = ImagePicker();
    _courseImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  writeData() async {
    File imageFile = File(_courseImage!.path);

    FirebaseStorage _storage = FirebaseStorage.instance;
    UploadTask _uploadTask =
        _storage.ref('courses').child(_courseImage!.name).putFile(imageFile);

    TaskSnapshot snapshot = await _uploadTask;
    _imageURL = await snapshot.ref.getDownloadURL();

    CollectionReference _aktuchange =
        FirebaseFirestore.instance.collection('mad4');
    _aktuchange.add({
      'course_name': _courseNameController.text,
      'course_fee': _courseFeeController.text,
      'img': _imageURL,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            TextField(
              controller: _courseNameController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Enter Food Name",
                hintStyle: TextStyle(
                    fontSize: 25.0,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.black, width: 3.0),
                ),
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(15),
                //   borderSide: BorderSide(
                //     color: Colors.teal,
                //   ),
                // ),
                prefixIcon: Icon(
                  Icons.emoji_food_beverage_outlined,
                  color: Colors.black,
                ),
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(15),
                // )
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _courseFeeController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Enter Price",
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(15),
                //   borderSide: BorderSide(color: Colors.indigo)
                // ),
                hintStyle: TextStyle(
                    fontSize: 25.0,
                    color: Colors.pink,
                    fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.black, width: 3.0),
                ),
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(15),
                //   borderSide: BorderSide(
                //     color: Colors.teal,
                //   ),
                // ),
                prefixIcon: Icon(
                  Icons.currency_pound,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                  child: _courseImage == null
                      ? IconButton(
                          icon: Icon(Icons.photo,size: 50, color: Colors.pink,),
                          onPressed: () {
                            chooseImageFromGC();
                          },
                        )
                      : Image.file(File(_courseImage!.path))),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 60,
                width: 150,
                child: ElevatedButton(
                    onPressed: () {
                      writeData();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    )),
                    child: Text(
                      "Add Image",
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
