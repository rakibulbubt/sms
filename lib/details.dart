import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

final Stream<QuerySnapshot> _imageStream =
    FirebaseFirestore.instance.collection("mad4").snapshots();

class _DetailsState extends State<Details> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
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
                height: 400,
                child: Card(
                  elevation: 10,
                  margin: EdgeInsets.all(20),
                  shadowColor: Colors.teal,
                  color: Colors.blueGrey,
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
                            padding: const EdgeInsets.all(25.0),
                            child: Container(
                              child: Text(data['course_name']),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Text(
                              data['course_fee'], textAlign: TextAlign.justify,
                              maxLines: 5,
                            ),
                          ),
                          GestureDetector(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.all(15),
                                child: Text('See More'),
                                decoration: BoxDecoration(
                                  color: Colors.lightGreen,
                                    borderRadius: BorderRadius.circular(15.0)),
                              ),
                            ),
                            onTap: (){
                              customDialogue(context, data['img'], data['course_name'], data['course_fee']);
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
    );
  }

  customDialogue(context, String img, String title, String desc){
    return showDialog(context: context, builder: (BuildContext context){
      return Dialog(
        child: Container(
          height: 600,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClipRRect(
                  child: Image.network(img),
                  borderRadius: BorderRadius.circular(15),
                ),
                Container(child: Text(title, style: TextStyle(fontSize: 20),),),
                Container(child: Text(desc, style: TextStyle(fontSize: 20),),),

              ],
            ),
          ),
        ),
      );
    });
  }
}
