
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myblog/Modules/Home_Screen/Home/home_states.dart';
import 'package:myblog/Modules/Home_Screen/Home_Screen.dart';
import '../../../Models/User.dart';
import '../../../Shared/Components/components.dart';
import '../../Shared/App_Colors.dart';
import '../Home_Screen/Home/home_cubit.dart';

class EditProfileSceen extends StatelessWidget {
  const EditProfileSceen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlogAppCubit.get(context);

    final userImageExists = cubit.userImage.existsSync();

    ImageProvider<Object>? backgroundImage;
    // if (!userImageExists) {
    //   backgroundImage = NetworkImage(cubit.myData!.image!);
    // } else if (cubit.userImage.existsSync() && cubit.userImage != null) {
    //   backgroundImage = FileImage(cubit.userImage);
    // }
    var nameController = TextEditingController();
    var ageController = TextEditingController();
    var phoneController = TextEditingController();
    var countryController = TextEditingController();
    var aboutController = TextEditingController();
    nameController.text = cubit.myData!.name!;
    ageController.text = cubit.myData!.age.toString();
    phoneController.text = cubit.myData!.phone!;
    countryController.text = cubit.myData!.country!;
    aboutController.text = cubit.myData!.about!;

    var formKey = GlobalKey<FormState>();

    return BlocConsumer<BlogAppCubit, BlogAppStates>(
      listener: (context, state) {},
      builder: (context, state) {

        if(state is BlogAppUploadUserImageSuccessState) backgroundImage = FileImage(cubit.userImage);
        else backgroundImage = NetworkImage(cubit.myData!.image!);

        return Scaffold(
          body: screenWithImage(
            Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        backArrow(context),
                        SizedBox(width: 10,),
                        myText(text: "Edit Profile",size: 30,bold: true,),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Stack(
                          //alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Center(
                              child: circleIconAvatar(
                                radius: 80,
                                //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  backgroundImage: backgroundImage,
                                  radius: 75.00,
                                ),
                              ),
                            ),
                            Positioned(
                              left: MediaQuery.of(context).size.width/2,
                              bottom: 0,
                              child: circleIconAvatar(
                                color: Colors.pink,
                                radius: 20,
                                child: Center(
                                  child: IconButton(
                                    icon:  Center(child: Icon(Icons.camera_alt,color: Colors.white,)),
                                    onPressed: () {
                                      BlogAppCubit.get(context).getUserImage();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    field(
                        //hieght: 200,
                        controller: nameController,
                        validator: (value) {
                          if (value.isEmpty) return 'Required';
                          return null;
                        },
                        label: "Name"),
                    const SizedBox(height: 10),
                    field(
                        controller: ageController,
                        validator: (value) {
                          if (value.isEmpty) return 'Required';
                          return null;
                        },
                        label: "Age"),
                    const SizedBox(height: 10),
                    field(
                        controller: phoneController,
                        validator: (value) {
                          if (value.isEmpty) return 'Required';
                          return null;
                        },
                        label: "Phone Number"),
                    const SizedBox(height: 10),
                    field(
                        controller: countryController,
                        validator: (value) {
                          if (value.isEmpty) return 'Required';
                          return null;
                        },
                        label: "Country"),
                    const SizedBox(height: 10),
                    field(
                        //hieght: 30,
                        controller: aboutController,
                        validator: (value) {
                          if (value.isEmpty) return 'Required';
                          return null;
                        },
                        label: "About"),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: button(
                            fun: () {
                              if (BlogAppCubit.get(context).userImage.existsSync()) {
                                BlogAppCubit.get(context).updateUserData(
                                  name: nameController.text,
                                  age: int.parse(ageController.text),
                                  phone: phoneController.text,
                                  country: countryController.text,
                                  about: aboutController.text,
                                );
                              } else {
                                BlogAppCubit.get(context).update(
                                  name: nameController.text,
                                  age: int.parse(ageController.text),
                                  phone: phoneController.text,
                                  country: countryController.text,
                                  about: aboutController.text,
                                );
                              }
                              delayNav(context, HomeScreen());
                            },
                            textButton: "Update",
                            size: 20,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        );
      },
    );
  }
}
