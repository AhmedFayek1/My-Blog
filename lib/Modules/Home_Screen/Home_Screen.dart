import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myblog/Models/User.dart';
import 'package:myblog/Modules/Home_Screen/Home/home_states.dart';
import 'package:myblog/Modules/Messanger/Messanger_cubit.dart';
import 'package:myblog/Modules/Nav_Drawer/nav_drawer.dart';
import 'package:myblog/Modules/Posts/Post_Screen.dart';

import 'package:myblog/Shared/Components/components.dart';
import 'package:myblog/Shared/notifications.dart';
import '../../Models/Blog.dart';
import '../../Shared/constants.dart';
import '../Messanger/Users_Chat_List/Chats_Screen.dart';
import '../Profile/Profile_Screen.dart';
import '../Search_Screen/Search_Screen.dart';
import 'Home/home_cubit.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var cubit = BlogAppCubit.get(context);
    return BlocConsumer<BlogAppCubit,BlogAppStates>(
      listener: (context,state) {},
      builder: (context,state) {
        return Scaffold(
          drawer: NavDrawer(),
          body: screenWithImage(
            Column(
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (context) {
                        return IconButton(onPressed: () {
                          Scaffold.of(context).openDrawer();
                        }, icon: Icon(Icons.menu));
                      }
                    ),
                    Expanded(child: Center(child: myText(text: "MyBlog",size: 30,bold: true,color: Colors.black))),
                   Spacer(),
                    IconButton(onPressed: () {
                      MyNotifications(context: context).pushNotification(cubit.myData!.token!, "Post Update", "Your Post Successfully Added");
                    }, icon: const Icon(Icons.notifications)),
                    IconButton(onPressed: () {navigate(context, SearchScreen());}, icon: const Icon(Icons.search)),
                    IconButton(onPressed: () {MessengerAppCubit.get(context).getUsersChats(context); delayNav(context, ChatScreen());}, icon: const Icon(Icons.message))
                  ],
                ),
                SizedBox(height: 30,),
                Expanded(
                  child: ConditionalBuilder(
                      condition: cubit.myData != null && cubit.allBlogs.isNotEmpty,
                      builder: (context) => SingleChildScrollView(
                        physics: const BouncingScrollPhysics(
                            decelerationRate: ScrollDecelerationRate.fast
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                //color: Colors.white38,
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: ()
                                      {
                                        navigate(context,ProfileScreen(cubit.myData!));
                                      },
                                      child: circleAvatar(
                                        image: cubit.myData!.image!,
                                        radius: 25.00,
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          delayNav(context, const PostScreen());
                                        },
                                        child: Container(
                                          height: 45,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            border: Border.all(width: 0.2),
                                            borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20),topLeft: Radius.circular(20)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: myText(text: "what's in your mind ...",size: 17),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.00,),
                            line(),
                            const SizedBox(height: 40.00,),
                            ConditionalBuilder(
                              condition: cubit.allBlogs.isNotEmpty && cubit.myData != null,
                              builder: (context) => SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        if(cubit.getUser(cubit.allBlogs[index].uID!) != null) {
                                          UserModel user = cubit.getUser(cubit.allBlogs[index].uID!)!;
                                              Blog blog = cubit.allBlogs[index];
                                          if ((user.locked! && user.followers!.contains(cubit.myData!.uID)) || !user.locked! || user.uID == uID) {
                                            return buildItemCard(
                                                cubit.allBlogs[index],
                                                context,
                                                index);
                                          }
                                        }
                                      },
                                      separatorBuilder: (context,index) => const SizedBox(height: 10.00,),
                                      itemCount: cubit.allBlogs.length,
                                    )
                                  ],
                                ),
                              ),
                              fallback: (context) => const Center(child: Text("No Blogs Yet")),
                            )],
                        ),
                      ),
                    fallback: (context) =>  Center(child: myText(text: "There is no blogs yet")),
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
  }

}

//Hassan@gmail.com
//111ZZZ/*/a@//