import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Models/User.dart';
import '../../../Shared/constants.dart';
import 'Register_States.dart';

class BlogAppRegisterCubit extends Cubit<BlogAppRegisterStates> {
  BlogAppRegisterCubit() : super(BlogAppRegisterInitialState());

  static BlogAppRegisterCubit get(context) => BlocProvider.of(context);

  Future<void> userRegister({
    required String username,
    required String email,
    required int age,
    required String country,
    required String password,
    required String confirmedPassword,
    required String phone,
  }) async {
    emit(BlogAppRegisterLoadingState());
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      CreateUser(
        username: username,
        email: email,
        age: age,
        country: country,
        uid: value.user!.uid,
        phone: phone,
      );
    }).catchError((onError) {
      //print(onError.code);
      emit(BlogAppRegisterErrorState(onError));
    });
  }

  bool passwordValidator(String value) {
    RegExp regExp = RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    if (regExp.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }

  Future <void> CreateUser({
    required String username,
    required String email,
    required int age,
    required String country,
    required String uid,
    required String phone,
  }) async {
    UserModel model;
    requestPermission();
    getToken()?.then((value) async {
      model = UserModel(
        name: username,
        email: email,
        phone: phone,
        age: age,
        about: "Hello There",
        image:
        "https://imgv3.fotor.com/images/blog-richtext-image/part-blurry-image.jpg",
        country: country,
        uID: uid,
        isEmailVerified: false,
        followers: [],
        following: [],
        token: myToken,
        blocked: [],
        locked: false,
      );
      uID = uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(model.toMap())
          .then((value) {
        emit(BlogAppCreateUserSuccessState());
      }).catchError((onError) {
        print(onError);
        emit(BlogAppCreateUserErrorState(onError));
      });
    }).catchError((onError) {
      emit(BlogAppCreateUserErrorState(onError));
    });
  }

  IconData icon = Icons.remove_red_eye_outlined;
  bool IsShown = true;

  void ChangeText() {
    IsShown = !IsShown;
    IsShown
        ? icon = Icons.remove_red_eye_outlined
        : icon = Icons.remove_red_eye;
    emit(BlogAppRegisterChangeText());
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted Permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted Provisional Permission");
    } else {
      print("User declined or has no accepted Permission");
    }
  }

  String? myToken;

  Future<void>? getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      myToken = token!;
    });
  }
}
// Ahmed
// 20
// EG
// 123456Aa
// 123456Aa
// 01111111111

//z@gmail.com
//z1@gmailcom
//z2@gmailcom
//z3@gmailcom