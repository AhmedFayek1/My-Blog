import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myblog/Modules/Home_Screen/Home_Screen.dart';

import '../../Shared/Components/components.dart';
import '../../Shared/Network/local/Cache_Helper.dart';
import '../Register_Screen/Register_Screen.dart';
import 'SocialLoginCubit/LoginCubit.dart';
import 'SocialLoginCubit/LoginStates.dart';

class BlogLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BlogAppLoginCubit(),
      child: BlocConsumer<BlogAppLoginCubit, BlogAppLoginStates>(
        listener: (context, state) {
          if (state is BlogAppLoginSuccessState) {
            CacheHelper.SaveData(key: 'uID', value: state.uID).then((value) {
              navigateToFinish(context, HomeScreen());
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
              body: screenWithImage(
            Center(
              child: SingleChildScrollView(
                child: Container( 
                  decoration: BoxDecoration(
                  color: Colors.white.withAlpha(150),
                    border: Border.all(width: 0.5,color: Colors.black), 
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(30.00),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            myText(text: "Login", size: 40, bold: true),
                            const SizedBox(
                              height: 10.00,
                            ),
                            if (state is BlogAppLoginErrorState)
                              errorLoginBox(state),
                            const SizedBox(
                              height: 20.00,
                            ),
                            field(
                                controller: emailController,
                                validator: (value) {
                                  if (value.isEmpty) return "Email Required";
                                  return null;
                                },
                                label: "Email Address",
                                icon: const Icon(Icons.email)),
                            const SizedBox(
                              height: 20.00,
                            ),
                            field(
                              controller: passwordController,
                              label: "Password",
                              icon: const Icon(Icons.lock),
                              validator: (value) {
                                if (value.isEmpty) return "Password Required";
                                return null;
                              },
                              suffix: IconButton(
                                  onPressed: () {
                                    BlogAppLoginCubit.get(context).ChangeText();
                                  },
                                  icon:
                                      Icon(BlogAppLoginCubit.get(context).icon,
                                      )),
                              obsecureText: BlogAppLoginCubit.get(context).IsShown,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  BlogAppLoginCubit.get(context).ChangeText();
                                },
                                icon: Icon(
                                  BlogAppLoginCubit.get(context).icon,
                                ),
                              ),
                              //type: TextInputType.visiblePassword,
                            ),
                            const SizedBox(
                              height: 30.00,
                            ),
                            ConditionalBuilder(
                              condition: state != BlogAppLoginLoadingState,
                              builder: (context) => button(
                                fun: () {
                                  if (formKey.currentState!.validate()) {
                                    BlogAppLoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                },
                                textButton: "LOGIN",
                                size: 20,
                              ),
                              fallback: (context) => const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            const SizedBox(
                              height: 30.00,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                myText(
                                  text: "Don't have account?",
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 20.00,
                                ),
                                TextButton(
                                    onPressed: () {
                                      delayNav(context, BlogRegisterScreen());
                                    },
                                    child: myText(
                                        text: "REGISTER", size: 20, bold: true)),
                              ],
                            ),
                            TextButton(
                                onPressed: () {
                                  BlogAppLoginCubit.get(context)
                                      .resetPassword(emailController.text);
                                },
                                child: myText(
                                    text: "Forget Password ?", bold: true))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ));
        },
      ),
    );
  }
}

//fayek@gmail.com
//12345878jAz/(_/

//Hassan@gmail.com
//123456789Aa
