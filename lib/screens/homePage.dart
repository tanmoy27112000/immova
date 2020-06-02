import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:immova/data/data.dart';
import 'package:immova/database/database.dart';
import 'package:immova/model/post.dart';
import 'package:immova/screens/imageUploadScreen.dart';
import 'package:provider/provider.dart';
import './postList.dart';
import 'package:mobile_popup/mobile_popup.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  int docLength = 0;

  final picker = ImagePicker();
  File image;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      value: DataBaseProvider().posts,
      child: Scaffold(
        floatingActionButton: fabButton(),
        appBar: appBarWidget(),
        body: Center(
          child: Container(
            child: isLoading
                ? CircularProgressIndicator()
                : docLength != 0
                    ? PostList()
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/cherry-searching.png')),
                            ),
                          ),
                          Text('!!!! No post yet !!!!',style: TextStyle(fontSize: 25),),
                        ],
                      ),
          ),
        ),
      ),
    );
  }

  AppBar appBarWidget() {
    return AppBar(
      title: Text(
        'Immova',
        style: TextStyle(
          letterSpacing: 1,
          fontWeight: FontWeight.w600,
          fontSize: 25,
        ),
      ),
      centerTitle: true,
    );
  }

  FloatingActionButton fabButton() {
    return FloatingActionButton.extended(
      backgroundColor: Colors.orange,
      elevation: 10,
      onPressed: () {
        showMobilePopup(
          context: context,
          builder: (context) => MobilePopUp(
            title: 'Select Source',
            leadingColor: Colors.white,
            child: Builder(
              builder: (navigator) => Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          pickImageCamera();
                        },
                        child: ListTile(
                          leading: Icon(Icons.camera),
                          title: Text('Camera'),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          pickImageGallery();
                        },
                        child: ListTile(
                          leading: Icon(Icons.photo),
                          title: Text('Gallery'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      label: Text(
        "Add post",
        style: TextStyle(
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  void pickImageGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      image = File(pickedFile.path);
      print(image.path);
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadImagePage(image, updateData),
        ));
  }

  void pickImageCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 80);
    setState(() {
      image = File(pickedFile.path);
      print(image.path);
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadImagePage(image, updateData),
        ));
  }

  void getData() async {
    docLength = await DataBaseProvider().getDocLength();
    print(docLength);
    setState(() {
      isLoading = false;
    });
  }

  updateData() {
    setState(() {});
  }
}
