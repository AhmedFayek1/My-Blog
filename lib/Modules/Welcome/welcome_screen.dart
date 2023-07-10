import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myblog/Modules/Login_Screen/Login_Screen.dart';
import 'package:myblog/Modules/Register_Screen/Register_Screen.dart';
import 'package:myblog/Shared/Components/components.dart';

class WelcomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenWithImage(
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
                    Center(
                      child: Row(
                        children: [
                          myText(text: "Welcome to ",size: 30),
                          myText(text: "myBlog ",size: 50, bold: true, color: Colors.pinkAccent),
                        ],
                      ),
                    ),
              //Image.asset('assets/images/onboarding2.png',fit: BoxFit.cover,),
              Spacer(),
              button(fun: () {
                navigateToFinish(context, BlogLoginScreen());
              }, textButton: "Log In",size: 25),
              SizedBox(height: 20,),
              button(fun: () {
                navigateToFinish(context, BlogRegisterScreen());
              }, textButton: "Sign Up",size: 25),
              SizedBox(height: 10,),
              TextButton(onPressed: () {}, child: myText(text: "Contact Us",size:20,bold: true)),
              SizedBox(height: 50,),
            ],
          ),
        )
      ),
    );
  }
}
