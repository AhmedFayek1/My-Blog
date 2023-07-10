import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myblog/Modules/Home_Screen/Home/home_states.dart';
import 'package:myblog/Modules/Posts/Post_Screen.dart';
import 'package:myblog/Shared/Components/components.dart';

import '../../Models/User.dart';
import '../../Shared/App_Colors.dart';
import '../Home_Screen/Home/home_cubit.dart';


class UsersScreen extends StatelessWidget {

  final List<UserModel> users;
  String title;
  String status;
  UsersScreen(this.users, {this.status = 'none',required this.title});

  @override
  Widget build(BuildContext context) {
    var cubit = BlogAppCubit.get(context);
    return BlocConsumer<BlogAppCubit,BlogAppStates>(
      listener: (context,state) {},
      builder: (context,state) {
        return Scaffold(
          body: screenWithImage(
            Column(
              children: [
                Row(children: [
                  backArrow(context),
                  Expanded(child: myText(text: title ,size: 25,bold: true))
                ]),
                SingleChildScrollView(
                  child: ConditionalBuilder(
                    condition: users.isNotEmpty,
                    builder: (context) => SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context,index) => buildUserItem(users[index],context,index,status: status),
                            separatorBuilder: (context,index) => const SizedBox(height: 10.00,),
                            itemCount: users.length,
                          )
                        ],
                      ),
                    ),
                    fallback: (context) => const Center(child: Text("No Users Yet")),
                  ),
                )],
            ),
          )
        );
      },
    );
  }

}
