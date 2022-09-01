import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sms/addnew_course.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

final Stream<QuerySnapshot> _imageStream =
    FirebaseFirestore.instance.collection("mad4").snapshots();

class _HomepageState extends State<Homepage> {
  addNewCourse() async {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => AddNewCourse());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Details'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _imageStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Vai aktu problem ase");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Container(
                height: 300,
                child: Card(
                  elevation: 10,
                  margin: EdgeInsets.all(20),
                  shadowColor: Colors.teal,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: ClipRRect(
                            child: Image.network(
                              data['img'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                child: Text(
                                  data['course_name'],
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Text(
                                data['course_fee'],
                                textAlign: TextAlign.justify,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.deepOrange),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 15, bottom: 15),
                                  margin: EdgeInsets.all(15),
                                  child: Text('See More',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)),
                                  decoration: BoxDecoration(
                                      color: Colors.lightGreen,
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                ),
                              ),
                              onTap: () {
                                customDialogue(context, data['img'],
                                    data['course_name'], data['course_fee']);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewCourse();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  customDialogue(context, String img, String title, String desc) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              color: Colors.yellowAccent,
              height: 350,
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(
                        img,
                        height: 250.0,
                        width: 200.0,
                      ),

                    ),
                    Container(
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      child: Text(
                        desc,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
