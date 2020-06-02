import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immova/data/data.dart';
import 'package:immova/model/post.dart';

class DataBaseProvider {
  final CollectionReference imageData =
      Firestore.instance.collection('imageData');

  getDocLength() async {
    QuerySnapshot doc = await imageData.getDocuments();
    for (var doc in doc.documents) {
      postListWidget.add(Post(
          imageUrl: doc.data["downloadUrl"],
          like: doc.data["like"],
          title: doc.data["title"]));
    }
    return doc.documents.length;
  }

  addImage({
    String downloadUrl,
    String title,
  }) async {
    await imageData.add({
      'downloadUrl': downloadUrl,
      'like': 0,
      'title': title,
    });
  }

  //getting post stream
  Stream<QuerySnapshot> get posts {
    return imageData.snapshots();
  }

  addLike({String imageUrl, int like, String title}) {
    like += 1;
    print("adding likes");
    imageData
        .where('downloadUrl', isEqualTo: imageUrl)
        .getDocuments()
        .then((value) async {
      String uid = value.documents[0].documentID;
      await imageData.document(uid).setData({
        'downloadUrl': imageUrl,
        'like': like,
        'title': title,
      });
    });
  }
}
