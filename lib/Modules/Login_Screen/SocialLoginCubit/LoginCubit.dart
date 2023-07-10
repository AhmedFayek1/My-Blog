

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myblog/Modules/Login_Screen/Login_Screen.dart';
import 'package:myblog/Shared/Components/components.dart';
import 'package:myblog/Shared/constants.dart';
import 'package:myblog/Shared/Network/local/Cache_Helper.dart';
import 'LoginStates.dart';

class BlogAppLoginCubit extends Cubit<BlogAppLoginStates> {
  BlogAppLoginCubit() : super(BlogAppLoginInitialState());

  static BlogAppLoginCubit get(context) => BlocProvider.of(context);


  void userLogin({
    required String email,
    required String password
  }) {
    emit(BlogAppLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      uID = value.user!.uid;
      emit(BlogAppLoginSuccessState(value.user!.uid));
    }).catchError((onError) {
      print(onError.code);
      emit(BlogAppLoginErrorState(onError));
    });
  }

  IconData icon = Icons.remove_red_eye_outlined;
  bool IsShown = true;

  void ChangeText() {
    IsShown = !IsShown;
    IsShown ? icon = Icons.remove_red_eye_outlined : icon =
        Icons.remove_red_eye;
    emit(BlogAppLoginChangeText());
  }

  void resetPassword(String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> signout(context) async {
    print('signout');
    await FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.RemoveData(key: 'uID');
      navigateToFinish(context, BlogLoginScreen());
      emit(BlogAppLoginSignOutState());
    });
  }
}
