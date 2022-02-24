import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok/resources/auth_methods.dart';
import 'package:tiktok/utils/utils.dart';

import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // string for displaying the error Message
  String? errorMessage;

  bool _secureText = true;
  bool _securityText = true;

  //image picker

  // our form key
  final _formKey = GlobalKey<FormState>();

  // editing Controller
  final fullNameEditingController = TextEditingController();
  final userNameEditingController = TextEditingController();
  final numEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    emailEditingController.dispose();
    passwordEditingController.dispose();
    fullNameEditingController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
        email: emailEditingController.text,
        password: passwordEditingController.text,
        fullname: fullNameEditingController.text,
        username: userNameEditingController.text,
        phone: numEditingController.text,
        file: _image!);

    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  /*void _cropImage(filePath) async{
    Uint8List? croppedImage = (await ImageCropper.cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080)) as Uint8List?;
    if (croppedImage ! = null){
      setState(() {
        _image = croppedImage;
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    //first name field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: fullNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Full Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        fullNameEditingController.text = value!;
      },
      maxLength: 30,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        counterText: "",
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        labelText: "Full Name",
      ),
    );

    //second name field
    final secondNameField = TextFormField(
      autofocus: false,
      controller: userNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("User Name is Must!");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        userNameEditingController.text = value!;
      },
      maxLength: 20,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        counterText: "",
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        labelText: "User Name",
      ),
    );

    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        fullNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        labelText: "Email Address",
      ),
    );

    //num field
    final numField = TextFormField(
      autofocus: false,
      controller: numEditingController,
      keyboardType: TextInputType.number,
      maxLength: 10,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter a number");
        }
        ;
        if (value.length < 10) {
          return ("Enter 10 digits");
        }
      },
      onSaved: (value) {
        fullNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        counterText: "",
        prefixIcon: Icon(Icons.phone),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        labelText: "Phone Number",
      ),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: _secureText,
      validator: (value) {
        RegExp regex = new RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter (Min. 8 letter, 1 Caps letter, 1 special letter, 1 Num)");
        }
      },
      onSaved: (value) {
        fullNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        suffixIcon: IconButton(
          icon: Icon(_secureText ? Icons.remove_red_eye : Icons.security),
          onPressed: () {
            setState(() {
              _secureText = !_secureText;
            });
          },
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        labelText: "Password",
      ),
    );

    //confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: _securityText,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Password don't match";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          suffixIcon: IconButton(
            icon: Icon(_securityText ? Icons.remove_red_eye : Icons.security),
            onPressed: () {
              setState(() {
                _securityText = !_securityText;
              });
            },
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          labelText: "Confirm Password",
        ));

    //signup button
    final signUpButton = Material(
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(50)),
      color: Colors.pinkAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          height: 60,
          elevation: 5,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final snackBar = SnackBar(content: Text('Submitting form'));
              _scaffoldKey.currentState!.showSnackBar(snackBar);
            }
            signUpUser();
          },
          child: Container(
            child: !_isLoading
                ? Text(
                    "Sign Up",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                : CircularProgressIndicator(
                    color: Colors.black,
                  ),
          )),
    );

    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Create an account",
                          style:
                              TextStyle(fontSize: 20, color: Colors.grey[700]),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Stack(
                          children: [
                            _image != null
                                ? CircleAvatar(
                                    radius: 64,
                                    backgroundImage: MemoryImage(_image!),
                                    backgroundColor: Colors.red,
                                  )
                                : const CircleAvatar(
                                    radius: 64,
                                    backgroundImage: NetworkImage(
                                        'https://i.stack.imgur.com/l60Hf.png'),
                                    backgroundColor: Colors.red,
                                  ),
                            Positioned(
                              bottom: -0,
                              left: 85,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: (BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueGrey,
                                )),
                                child: IconButton(
                                  onPressed: selectImage,
                                  icon: const Icon(Icons.add_a_photo),
                                  iconSize: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    /*UserImage(onFileChanged: (imageUrl) {
                      setState(() {
                        this.imageUrl = imageUrl;
                      });
                    }),
                     importProfile(),
                    SizedBox(
                      height: 15,
                    ),*/
                    SizedBox(height: 45),
                    firstNameField,
                    SizedBox(height: 35),
                    secondNameField,
                    SizedBox(height: 35),
                    emailField,
                    SizedBox(height: 35),
                    numField,
                    SizedBox(height: 35),
                    passwordField,
                    SizedBox(height: 35),
                    confirmPasswordField,
                    SizedBox(height: 35),
                    signUpButton,
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                          text: "Already have an account?",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: "Signin",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

/*
  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
*/

/*
  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sending these values

    FirebaseFirestore _firebase = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
     userModel.email = user!.email!;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.lastName = lastNameEditingController.text;
    userModel.phone = numEditingController.text;
    await _firebase.collection("users").doc(user.uid).set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

     Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }
*/

}
