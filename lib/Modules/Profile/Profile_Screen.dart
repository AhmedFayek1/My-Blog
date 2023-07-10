import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myblog/Modules/Home_Screen/Home/home_states.dart';
import 'package:myblog/Modules/Messanger/Messanger_cubit.dart';
import 'package:myblog/Modules/Posts/Post_Screen.dart';
import 'package:myblog/Modules/Edit_Profile/edit_screen.dart';
import 'package:myblog/Shared/constants.dart';
import '../../Models/User.dart';
import '../../Shared/Components/components.dart';
import '../Home_Screen/Home/home_cubit.dart';
import '../Messanger/User_Chat/user_chat.dart';
import '../Users/users_screen.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;

  ProfileScreen(this.user);
  @override
  Widget build(BuildContext context) {
    var cubit = BlogAppCubit.get(context);
    return BlocConsumer<BlogAppCubit, BlogAppStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return Scaffold(
            body: screenWithImage
              (
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                  children: [
                    Row(
                      children: [
                        circleIconAvatar(child: backArrow(context)),
                        Spacer(),
                        circleIconAvatar(
                          child: menu(
                            fun: (String value) {
                              cubit.userSettings(context, value, user);
                          },
                            list: user.uID == uID ? [
                            "Edit Profile",
                            "Blocked Users",
                            cubit.myData!.locked! ? "Unlock" : "Lock",
                            "Log Out"
                          ]: [
                            "follow",
                            "Message",
                            cubit.myData!.blocked!.contains(user.uID) ? "Unblock" : "Block",
                          ],
                          ),
                        )

                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ConditionalBuilder(
                      condition: user != null,
                      builder: (context) => SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: Container(
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 30,
                                        ),
                                        circleIconAvatar(
                                          radius: 75,
                                          child: circleAvatar(
                                            image: user.image!,
                                            radius: 70.00,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        myText(
                                            text: user.name!,
                                            size: 30,
                                            bold: true,
                                        ),
                                        myText(
                                            text: user.about!,
                                            size: 20,
                                            bold: true,),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                           border: Border.all(width: 0.2),
                                           gradient:  LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [Colors.redAccent.withAlpha(200), Colors.pinkAccent.withAlpha(200)]
                                           ),
                                          ),
                                          //elevation: 5.0,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 22.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              //crossAxisAlignment: CrossAxisAlignment.,
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    myText(
                                                      text: "Followers",
                                                      size: 22.0,
                                                      bold: true,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        List<UserModel> users =
                                                        BlogAppCubit.get(context)
                                                            .listUsers(
                                                            user.followers!);
                                                        delayNav(context,
                                                            UsersScreen(users,title: 'Followers',));
                                                      },
                                                      child: myText(
                                                        text:
                                                        "${user.followers!.length}",
                                                        size: 20.0,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: <Widget>[

                                                    myText(
                                                        text: "Posts",
                                                        size: 22.0,
                                                        bold: true,
                                                        color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    myText(
                                                      text: "${cubit.usersBlogs.containsKey(user.uID) ? cubit.usersBlogs[user.uID]!.length : '0'}",
                                                      size: 20.0,
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: <Widget>[
                                                    myText(
                                                      text: "Following",
                                                      size: 22.0,
                                                      bold: true,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        List<UserModel> users =
                                                        BlogAppCubit.get(context)
                                                            .listUsers(
                                                            user.following!);
                                                        delayNav(context,
                                                            UsersScreen(users,title: 'Following',));
                                                      },
                                                      child: myText(
                                                        text:
                                                        "${user.following!.length}",
                                                        size: 20.0,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.00),
                              if(user.uID == uID)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 40.00,
                                        width: double.infinity,
                                        child: button(
                                          fun: () {
                                            delayNav(context, PostScreen());
                                          },
                                          textButton: "ADD BLOG",
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                      Expanded(
                                        child: Container(
                                          height: 40.00,
                                          width: double.infinity,
                                          child: button(
                                            fun: () {
                                              delayNav(context, EditProfileSceen());
                                            },
                                            textButton: "EDIT PROFILE",
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              if(user.uID != uID)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 40.00,
                                        width: double.infinity,
                                        child: button(
                                          fun: () {
                                            cubit.follow(user, context: context);
                                          },
                                          textButton: cubit.myData!.following
                                          !.contains(user.uID)
                                              ? "UnFollow"
                                              : "Follow",
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                      Expanded(
                                        child: Container(
                                          height: 40.00,
                                          //width: double.infinity,
                                          child: button(
                                            fun: () { 
                                                MessengerAppCubit.get(context).getMessages(receiverID: user.uID!);
                                                navigate(context, ChatDetails(userModel: user));
                                            },
                                            textButton: "MESSAGE",
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              SizedBox(
                                height: 20.00,
                              ),
                              if(user.uID == uID || !user.locked! || (user.locked! && user.followers!.contains(uID)))
                                ConditionalBuilder(
                                condition: cubit.usersBlogs.containsKey(user.uID),
                                builder: (context) => SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) => buildItemCard(
                                            cubit.usersBlogs[user.uID]![index], context, index),
                                        separatorBuilder: (context, index) =>
                                        const SizedBox(
                                          height: 10.00,
                                        ),
                                        itemCount: cubit.usersBlogs[user.uID]!.length,
                                      )
                                    ],
                                  ),
                                ),
                                fallback: (context) =>
                                    Center(child: myText(text: "No Posts")),
                              ),
                              if(user.locked! && (user.uID != uID || user.followers!.contains(uID)))
                                Center(
                                  child: myText(
                                    text: "This Account is Locked",
                                    size: 20,
                                    bold: true,
                                    color: Colors.red,
                                  ),
                                )
                            ]),
                      ),
                      fallback: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
            ),
                    ),
                  ],
              ),
                )));

      },
    );
  }
}

//fyeka002@gmail.com
//12345878jAz/(_/
