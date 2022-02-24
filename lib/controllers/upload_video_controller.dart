/*
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/models/post.dart';
import 'package:tiktok/resources/storage_methods.dart';
import 'package:tiktok/utils/global_variables.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  String photoUrl = "",
      userName = "",
      description = "",
      time = "",
      user_id = "",
      profImage = "",
      songName = "",
      caption = "",
      */
/*songName = "",
      caption ="",*/ /*

      videoPath = "",
      videoUrl = "";


  Uint8List? _file;

  bool isLoading = false;

  final TextEditingController _descriptionController = TextEditingController();

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

*/
/*
  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }
*/ /*


*/
/*
  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
*/ /*


  // upload video
  //uploadVideo(String songName, String caption, String videoPath) async {
  Future<String> uploadVideo() async {
    try {
      String docId = FirebaseFirestore.instance.collection('posts').doc().id;

      String profImage =
          await StorageMethods().uploadImageToStorage('posts', _file!, true);

      // String uid = firebaseAuth.currentUser!.uid;
      ///DocumentSnapshot userDoc =
      ///  await firestore.collection('users').doc(uid).get();
      // get id
      var allDocs = await firestore.collection('posts').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      //String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

*/
/*Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        thumbnail: thumbnail,
      );*/ /*


      Post post = Post(
        description: _descriptionController.text,
        uid: user_id,
        username: userName,
        likes: [],
        postId: docId,
        datePublished: DateTime.now(),
        postUrl: profImage,
        profImage: photoUrl,
        id: "",
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
      );

      await firestore.collection('posts').doc(docId).set(
            post.toJson(),
          );
      firestore
          .collection('users')
          .doc(user_id)
          .collection("MyPosts")
          .doc(docId)
          .set(post.toJson());

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
    }
  }
}
*/
