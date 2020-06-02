import 'dart:io';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:immova/data/data.dart';
import 'package:immova/database/database.dart';
import 'package:immova/model/post.dart';
import 'package:overlay_support/overlay_support.dart';

class UploadImagePage extends StatefulWidget {
  File image;
  Function updateData;
  UploadImagePage(this.image, this.updateData);

  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://immova-3230d.appspot.com');
  StorageUploadTask _uploadTask;
  TextEditingController titleController = TextEditingController();
  bool isUploading = false;
  @override
  void initState() {
    super.initState();
    print(widget.image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload image',
          style: TextStyle(
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: widget.image == null
          ? Center(
              child: Text('No image selected.'),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  imageContainer(context),
                  textFieldWidget(),
                  isUploading
                      ? CircularProgressIndicator()
                      : uploadButton(context),
                ],
              ),
            ),
    );
  }

  Padding uploadButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: InkWell(
        onTap: () {
          uploadImage();
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 1.08,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  spreadRadius: 0)
            ],
            color: Colors.black,
          ),
          child: Center(
            child: Text(
              "UPLOAD",
              style: TextStyle(
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.normal,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding textFieldWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Text(
              "Title",
              style: kTextStyle.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: titleController,
                  autofocus: false,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "enter the name ",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  var kTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 30,
    letterSpacing: 1,
  );
  Container imageContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Center(
        child: Container(
          margin: EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width / 1.1,
          height: MediaQuery.of(context).size.width / 1.1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: FileImage(
                widget.image,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  void uploadImage() async {
    setState(() {
      isUploading = true;
    });
    String downloadUrl = await uploadPhoto();
    DataBaseProvider()
        .addImage(downloadUrl: downloadUrl, title: titleController.text);
    postListWidget.add(
      Post(
        imageUrl: downloadUrl,
        like: 0,
        title: titleController.text,
      ),
    );
    widget.updateData();
    print(downloadUrl);
    setState(() {
      isUploading = false;
    });
    showSimpleNotification(
        Text(
          "Image posted.🎉🎉🎉🎉",
          style: TextStyle(color: Colors.white),
        ),
        background: Colors.green);
  }

  Future<String> uploadPhoto() async {
    String format = widget.image.path.split('.').last;
    String filePath = 'images/${DateTime.now()}.' + format;
    print(filePath);
    _uploadTask = _storage.ref().child(filePath).putFile(widget.image);
    StorageTaskSnapshot storageTaskSnapshot = await _uploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
