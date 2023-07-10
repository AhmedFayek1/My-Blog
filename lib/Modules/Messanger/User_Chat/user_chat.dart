import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myblog/Modules/Home_Screen/Home/home_cubit.dart';
import 'package:myblog/Modules/Profile/Profile_Screen.dart';
import '../../../Models/Chat_Model/Chat_Model.dart';
import '../../../Models/User.dart';
import '../../../Shared/Components/components.dart';
import '../../../Shared/constants.dart';
import '../Messanger_cubit.dart';
import '../Messanger_states.dart';
class ChatDetails extends StatelessWidget {
  UserModel userModel;

  var messageController = TextEditingController();
  ChatDetails({required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (BuildContext context) {

      return BlocConsumer<MessengerAppCubit,MessengerAppStates> (
        listener: (context,state) {},
        builder: (context,state) {
          //List<ChatModel>? messages = MessengerAppCubit.get(context).messages[userModel.uID];
          var homeCubit = BlogAppCubit.get(context);
          var MessengerCubit = MessengerAppCubit.get(context);

          return Scaffold(
            body: screenWithImage(
              Column(
                      children: [
                        Row(
                          children: [
                            backArrow(context),
                            InkWell(
                              onTap: () {
                                navigate(context, ProfileScreen(homeCubit.getUser(userModel.uID!)!));
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(userModel.image!),
                                radius: 15.00,
                              ),
                            ),
                            SizedBox(width: 15.00,),
                            Text(userModel.name!,style: TextStyle(height: 1.3,fontWeight: FontWeight.bold,fontSize: 25.00),),
                          ],

                        ),
                        Expanded(
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                              itemBuilder: (context,index) {
                                 var message = MessengerCubit.messages[index];
                                if(uID == message.senderID)
                                  return buildMyMessage(message,context);
                                else
                                  return buildYourMessage(message,context);
                              },
                              separatorBuilder: (context,index) => SizedBox(height: 10.00,),
                              itemCount: MessengerCubit.messages.length,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.00),
                                topLeft: Radius.circular(10.00),
                                bottomLeft: Radius.circular(10.00),
                                bottomRight: Radius.circular(10.00),
                              )
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.00),
                                  child: TextFormField(
                                    controller: messageController,
                                    decoration: InputDecoration(
                                      hintText: 'Type your message here ...',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      MessengerCubit.getMessageImage();
                                    },
                                    icon: Icon(Icons.image),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if(MessengerCubit.messageImage.existsSync() && MessengerCubit.messageImage != null)
                                      {
                                        MessengerCubit.sendImageMessage(
                                            receiverID: userModel.uID!,
                                            text: messageController.text,
                                            datetime: DateTime.now().toString()
                                        );
                                        //MessengerCubit.messageImage.delete();
                                      }
                                      else if(messageController.text != '')
                                      {
                                        MessengerCubit.sendChat(
                                            receiverID: userModel.uID!,
                                            text: messageController.text,
                                            datetime: DateTime.now().toString());
                                      }
                                      messageController.text = '';
                                    },
                                    icon: Icon(Icons.send),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
            ),
             );
          },
        );
      },
    );

  }


  Widget buildMyMessage(ChatModel model, BuildContext context) => Align(
    alignment: Alignment.topRight,
    child: Column(
      children: [
        if(model.text != '' || model.image != null)
         Container(
            decoration: BoxDecoration(
                color: Colors.red[300],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15.00),
                  topLeft: Radius.circular(15.00),
                  bottomLeft: Radius.circular(15.00),
                )
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.00,horizontal: 10.00),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if(model.text != '')
                    myText(context: context,text:model.text!,size: 20.00,bold: true,color: Colors.white),
                  if(model.image != null)
                   Image(image: NetworkImage(model.image!),),
                  //model.image = null,
                ],
              ),
            )
        ),
      ],
    ),
  );

  Widget buildYourMessage(ChatModel model, BuildContext context) => Align(
    alignment: Alignment.topLeft,

    child: Column(
      children: [
        if(model.text != '' || model.image != null)
          Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15.00),
                    topLeft: Radius.circular(15.00),
                    bottomRight: Radius.circular(15.00),
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.00,horizontal: 10.00),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if(model.text != '')
                      myText(context: context, text:model.text!,size: 20.00,bold: true,color: Colors.white),
                    if(model.image != null)
                      Image(image: NetworkImage(model.image!),),
                  ],
                ),
              )
          ),
       ],
     ),
   );
}
