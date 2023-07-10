
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myblog/Models/User.dart';
import 'package:myblog/Modules/Login_Screen/SocialLoginCubit/LoginCubit.dart';
import 'package:myblog/Modules/Profile/Profile_Screen.dart';
import 'package:myblog/Modules/Saved_Blogs/saved_blogs_screen.dart';
import 'package:myblog/Modules/Users/users_screen.dart';

import '../../Shared/App_Colors.dart';
import '../../Shared/Components/components.dart';
import '../../Shared/constants.dart';
import '../Home_Screen/Home/home_cubit.dart';
import '../Home_Screen/Home/home_states.dart';
import '../Messanger/Users_Chat_List/Chats_Screen.dart';
class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogAppCubit,BlogAppStates>(
        listener: (context,state) {},
    builder: (context,state) {
          BuildContext context2 = context;
    var cubit = BlogAppCubit.get(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 300,
            child: DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white38,Colors.pink],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(

                children: [
                  CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(cubit.myData!.image!),
                ),
                  const SizedBox(height: 10,),
                  myText(text: cubit.myData!.name!,size: 20,bold: true,color: Colors.white,),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      myText(text: cubit.myData!.followers!.length.toString() + " Followers",size: 15,color: Colors.white,),
                      const SizedBox(width: 10,),
                      Icon(Icons.people,size: 15,color: Colors.white,)
                    ],
                  )
              ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: myText(text:'Profile'),
            onTap: () => {
                navigate(context,ProfileScreen(cubit.myData!))
            },
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: myText(text:'Messages'),
            onTap: () => {
                navigate(context,ChatScreen())
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: myText(text:'Users'),
            onTap: ()  {
                List<UserModel> allUsers = cubit.allUsers;
                allUsers.forEach((element) {
                  if(element.uID == uID) allUsers.remove(element);
                });
                navigate(context,UsersScreen(allUsers, title: 'Matual Friends',));
            },
          ),

          ListTile(
            leading: Icon(Icons.save),
            title: myText(text:'Saved'),
            onTap: () => {
              delayNav(context,SavedBlogsScreen()),
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: myText(text:'Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: myText(text:'Logout'),
            onTap: () => {
              BlogAppLoginCubit.get(context).signout(context),
            },
          ),
          SizedBox(height: 30,),
          line(),

          ListTile(
            leading: Icon(Icons.phone),
            title: myText(text:'Contact Us'),
            onTap: () => {

            },
          ),

          ListTile(
            leading: Icon(Icons.question_mark),
            title: myText(text:'Help and Support'),
            onTap: () => {
              //cubit.signOut(context),
            },
          ),
        ],
      ),
    );
  }
    );
  }

}