import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../layouts/mobile_screen_layout.dart';
import '../models/post.dart';
import '../resources/storage_methods.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import '../widgets/text_input_field.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  const ConfirmScreen({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  //Uint8List? _file;

  String photoUrl = "",
      userName = "",
      description = "",
      time = "",
      user_id = "",
      profImage = "",
      songName = "",
      caption = "",
      videoPath = "",
      videoUrl = "";

  String isPhoto = "";

  bool isLoading = false;

  late VideoPlayerController controller;
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  /*UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());*/

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    _fetch();
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  uploadVideo(String songName, String caption, String videoPath) async {
    setState(() {
      isLoading = true;
    });

    String res = "Some error";

    try {
      String docId = FirebaseFirestore.instance.collection('posts').doc().id;

      /*String profImage =
          await StorageMethods().uploadImageToStorage('posts', _file!, true);*/

      // var allDocs = await firestore.collection('posts').get();
      /*int len = docId.docs.length;*/
      String videoUrl =
          await StorageMethods().uploadVideoToStorage('posts', videoPath, true);

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
        isPhoto: isPhoto == "true" ? true : false,
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
      if (res == "Success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted! :)',
        );
        //clearVideo();
      } else {
        showSnackBar(context, res);
      }

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
    }
  }

  /*void clearVideo() {
    setState(() {
      _file = null;
    });
  }*/

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: VideoPlayer(controller),
            ),
            const SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _songController,
                      labelText: 'Song Name',
                      icon: Icons.music_note,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _captionController,
                      labelText: 'Caption',
                      icon: Icons.closed_caption,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () => uploadVideo(_songController.text,
                              _captionController.text, widget.videoPath)
                          .whenComplete(() => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => MobileScreenLayout()))),
                      child: const Text(
                        'Post!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _fetch() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) async {
        setState(() {
          photoUrl = ds.data()!["photoUrl"];
          userName = ds.data()!["username"];
          user_id = ds.data()!["uid"];
        });
      }).catchError((e) {
        print(e);
      });
    }
  }
}
