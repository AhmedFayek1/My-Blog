import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myblog/Modules/Home_Screen/Home/home_cubit.dart';
import 'package:myblog/Modules/Home_Screen/Home/home_states.dart';
import 'package:myblog/Shared/App_Colors.dart';
import 'package:myblog/Shared/Components/components.dart';

import '../../Models/Blog.dart';

class EditBlogScreen extends StatelessWidget {
  Blog blog;

  EditBlogScreen(this.blog, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogAppCubit, BlogAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = BlogAppCubit.get(context);
        var blogController = TextEditingController();
        var category;
        var audience;
        blogController.text = blog.blog!;
        category = blog.category;
        audience = blog.audience;

        return Scaffold(
          backgroundColor: background,
          body: screenWithImage(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      backArrow(context),
                      const SizedBox(
                        width: 20,
                      ),
                      myText(text: "Update blog", size: 25, bold: true),
                      const Spacer(),
                      if (state is ChangeDrobDownMenuItemState)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                              onPressed: () {
                                if (cubit.blogImage.existsSync()) {
                                  cubit.updateBlogDataWithImage(
                                      blogg: blog,
                                      blog: blogController.text,
                                      category: cubit.category,
                                      audience: cubit.aud);
                                } else {
                                  cubit.updateBlogData(
                                      blogg: blog,
                                      blog: blogController.text,
                                      category: cubit.category,
                                      audience: cubit.aud);
                                }
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Update",
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 20.00,
                  ),
                  Row(children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          BlogAppCubit.get(context).myData!.image!),
                      radius: 25.00,
                    ),
                    const SizedBox(
                      width: 15.00,
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              BlogAppCubit.get(context).myData!.name!,
                              style: const TextStyle(
                                  height: 1.3,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.00),
                            )
                          ]),
                    ),
                  ]),
                  Row(
                    children: [
                      drobMenu(
                        context: context,
                        fun: (value) {
                          BlogAppCubit.get(context).setCategories(value);
                          category = value;
                        },
                        list: BlogAppCubit.get(context).categories,
                        text: cubit.category,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      drobMenu(
                        context: context,
                        fun: (value) {
                          BlogAppCubit.get(context).setAudience(value);
                          audience = value;
                        },
                        list: BlogAppCubit.get(context).audience,
                        text: cubit.aud,
                      )
                    ],
                  ),
                  Expanded(
                    child: field(
                      hieght: 200,
                      controller: blogController,
                      validator: (value) {
                        if (value.isEmpty) return 'Required';
                        return null;
                      },
                      label: "Write Your Blog",
                      outLineBorder: false,
                      //maxLine: null!,
                    ),
                  ),
                  if (!cubit.blogImage.existsSync() && blog.image != null)
                    SizedBox(
                      height: 190,
                      child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.00),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 150.00,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5.00)),
                                          image: DecorationImage(
                                              image: NetworkImage(blog.image!),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.00),
                                          child: IconButton(
                                            icon: const CircleAvatar(
                                                radius: 17,
                                                child: Icon(
                                                    Icons.highlight_remove)),
                                            onPressed: () {
                                              cubit.RemovePostImage();
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ]),
                    ),
                  if (cubit.blogImage.existsSync())
                    SizedBox(
                      height: 190,
                      child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.00),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 150.00,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5.00)),
                                          image: DecorationImage(
                                              image: FileImage(cubit.blogImage),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.00),
                                          child: IconButton(
                                            icon: const CircleAvatar(
                                                radius: 17,
                                                child: Icon(
                                                    Icons.highlight_remove)),
                                            onPressed: () {
                                              cubit.RemovePostImage();
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ]),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(
                            onPressed: () {
                              cubit.getBlogImage();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.image,
                                    color: Colors.pinkAccent),
                                const SizedBox(
                                  width: 5.00,
                                ),
                                myText(
                                    text: "Add photo",
                                    color: Colors.pinkAccent),
                              ],
                            ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
