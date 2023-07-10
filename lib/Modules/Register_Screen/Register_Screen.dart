import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:myblog/Modules/Home_Screen/Home_Screen.dart';
import 'package:myblog/Modules/Login_Screen/Login_Screen.dart';
import 'package:myblog/Shared/App_Colors.dart';
import '../../Shared/Components/components.dart';
import 'Register_Cubit/Register_Cubit.dart';
import 'Register_Cubit/Register_States.dart';

class BlogRegisterScreen extends StatelessWidget {
  var userNameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var ageController = TextEditingController();
  var countryController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BlogAppRegisterCubit(),
      child: BlocConsumer<BlogAppRegisterCubit, BlogAppRegisterStates>(
        listener: (context, state) {
          if (state is BlogAppCreateUserSuccessState) {
            navigateToFinish(context,HomeScreen());
            showToast(
                message: "Successful Process", state: ToastStates.SUCCESS);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: screenWithImage(
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withAlpha(150),
                      border: Border.all(width: 0.5,color: Colors.black),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(30.00),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            myText(text: "Register", size: 40, bold: true),
                            SizedBox(height: 5.00,),
                            if (state is BlogAppRegisterErrorState)
                              errorRegisterationBox(state),
                            SizedBox(height: 30.00,),
                            field(
                                controller: userNameController,
                                validator: (value) {
                                  if (value.isEmpty) return "Name Required";
                                  return null;
                                },
                                label: "User Name",
                                icon: Icon(Icons.person)),
                            field(
                                controller: emailController,
                                validator: (value) {
                                  if (value.isEmpty) return "Email Required";
                                  return null;
                                },
                                label: "Email Address",
                                icon: Icon(Icons.email)),
                            Row(
                              children: [
                                Expanded(
                                  child: field(
                                      controller: ageController,
                                      validator: (value) {
                                        if (value.isEmpty) return "Age Required";
                                        return null;
                                      },
                                      label: "Age",
                                      icon: Icon(Icons.numbers)),
                                ),
                                SizedBox(width: 10.00,),
                                Expanded(
                                  child: field(
                                      controller: countryController,
                                      validator: (value) {
                                        if (value.isEmpty) return " Country Required";
                                        return null;
                                      },
                                      label: "Country",
                                      icon: Icon(Icons.vpn_lock)),
                                ),
                              ],
                            ),
                            field(
                              controller: passwordController,
                              validator: (value) {
                                if (value.isEmpty)
                                  return "Password Required";
                                else if (!BlogAppRegisterCubit.get(context)
                                    .passwordValidator(value))
                                  return 'password very weak';
                                return null;
                              },
                              label: "Password",
                              icon: Icon(Icons.lock),
                              obsecureText: BlogAppRegisterCubit.get(context).IsShown,
                              suffix: IconButton(
                                onPressed: () {
                                  BlogAppRegisterCubit.get(context).ChangeText();
                                },
                                icon: Icon(
                                  BlogAppRegisterCubit.get(context).icon,
                                ),
                              ),
                              //type: TextInputType.visiblePassword,
                            ),
                         field(
                              controller: confirmPasswordController,
                              validator: (value) {
                                if (value.isEmpty)
                                  return "Password Confirmation Required";
                                else if (confirmPasswordController.text !=
                                    passwordController.text)
                                  return 'password does not match';
                                return null;
                              },
                              label: "Confirm Password",
                              icon: Icon(Icons.lock),
                              obsecureText: BlogAppRegisterCubit.get(context).IsShown,
                              suffix: IconButton(
                                onPressed: () {
                                  BlogAppRegisterCubit.get(context).ChangeText();
                                },
                                icon: Icon(
                                  BlogAppRegisterCubit.get(context).icon,
                                ),
                              ),
                              //type: TextInputType.visiblePassword,
                            ),
                            field(
                              controller: phoneController,
                              validator: (value) {
                                if (value.isEmpty) return "Phone Required";
                                return null;
                              },
                              label: "Phone Number",
                              icon: Icon(Icons.phone),
                            ),
                            SizedBox(
                              height: 20.00,
                            ),
                            button(
                              fun: () {
                                if (formKey.currentState!.validate()) {
                                  print(emailController.text);
                                  print(passwordController.text);

                                  BlogAppRegisterCubit.get(context).userRegister(
                                      username: userNameController.text,
                                      email: emailController.text,
                                      age: int.parse(ageController.text),
                                      country: countryController.text,
                                      password: passwordController.text,
                                      confirmedPassword: confirmPasswordController.text,
                                      phone: phoneController.text);
                                }
                              },
                              textButton:
                              "Register", size: 20,
                            ),
                            const SizedBox(
                              height: 30.00,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                myText(
                                  text: "Alraedy have an account?",
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 20.00,
                                ),
                                TextButton(
                                    onPressed: () {
                                      delayNav(context, BlogLoginScreen());
                                    },
                                    child: myText(
                                        text: "LOGIN", size: 20, bold: true)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          );
        },
      ),
    );
  }
}
