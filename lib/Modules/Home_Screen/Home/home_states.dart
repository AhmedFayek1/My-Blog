abstract class BlogAppStates {}

class BlogAppInitialState extends BlogAppStates{}

class BlogAppGetCurrentUserDataSuccessState extends BlogAppStates{}

class BlogAppGetCurrentUserDataErrorState extends BlogAppStates{
  final error;
  BlogAppGetCurrentUserDataErrorState(this.error);
}

class BlogAppGetUserDataSuccessState extends BlogAppStates{}

class BlogAppGetUserDataErrorState extends BlogAppStates{
  final error;
  BlogAppGetUserDataErrorState(this.error);
}
class BlogAppUploadBlogLoadingState extends BlogAppStates{}

class BlogAppUploadBlogSuccessState extends BlogAppStates{}

class BlogAppUploadBlogErrorState extends BlogAppStates{
  final error;
  BlogAppUploadBlogErrorState(this.error);
}

class BlogAppGetUserBlogsSuccessState extends BlogAppStates{}

class BlogAppGetBlogSuccessState extends BlogAppStates{}

class BlogAppGetBlogErrorState extends BlogAppStates{
  final error;
  BlogAppGetBlogErrorState(this.error);
}

class BlogAppGetAllBlogsSuccessState extends BlogAppStates{}

class BlogAppGetAllBlogsErrorState extends BlogAppStates{
  final error;
  BlogAppGetAllBlogsErrorState(this.error);
}

class Success extends BlogAppStates{}

class BlogAppUpdateBlogSuccessState extends BlogAppStates{}

class BlogAppUpdateBlogErrorState extends BlogAppStates {
  final error;

  BlogAppUpdateBlogErrorState(this.error);
}

class BlogAppDeleteBlogSuccessState extends BlogAppStates{}

class BlogAppDeleteBlogErrorState extends BlogAppStates{
  final error;
  BlogAppDeleteBlogErrorState(this.error);
}

class BlogAppUpdateUserDataSuccessState extends BlogAppStates{}

class BlogAppUpdateUserDataErrorState extends BlogAppStates{
  final error;
  BlogAppUpdateUserDataErrorState(this.error);
}

class BlogAppUplodeCoverImageSuccessState extends BlogAppStates{}

class BlogAppUplodeCoverImageErrorState extends BlogAppStates{
  final error;
  BlogAppUplodeCoverImageErrorState(this.error);
}




class BlogAppUplodeBlogImageSuccessState extends BlogAppStates{}

class BlogAppUplodeBlogImageErrorState extends BlogAppStates{
  final error;
  BlogAppUplodeBlogImageErrorState(this.error);
}

class BlogAppRemovePostImageSuccessState extends BlogAppStates{}


class BlogAppUploadUserImageSuccessState extends BlogAppStates{}

class BlogAppUploadUserImageErrorState extends BlogAppStates{}



class BlogAppUploadBlogImageSuccessState extends BlogAppStates{}

class BlogAppUploadBlogImageErrorState extends BlogAppStates{}

class BlogAppAddLikeSuccessState extends BlogAppStates{}

class BlogAppAddLikeErrorState extends BlogAppStates{
  final error;

  BlogAppAddLikeErrorState(this.error);
}

class BlogAppRemoveLikeSuccessState extends BlogAppStates{}

class BlogAppRemoveLikeErrorState extends BlogAppStates{
  final error;

  BlogAppRemoveLikeErrorState(this.error);
}

class BlogAppSendFollowSuccessState extends BlogAppStates{}

class BlogAppSendFollowErrorState extends BlogAppStates{
  final error;

  BlogAppSendFollowErrorState(this.error);
}

class BlogAppRemoveFollowSuccessState extends BlogAppStates{}

class BlogAppRemoveFollowErrorState extends BlogAppStates{
  final error;

  BlogAppRemoveFollowErrorState(this.error);
}

class BlogAppSaveBlogSuccessState extends BlogAppStates{}

class BlogAppSaveBlogErrorState extends BlogAppStates{
  final error;

  BlogAppSaveBlogErrorState(this.error);
}

class BlogAppSignOutSuccessState extends BlogAppStates{}

class BlogAppSignOutErrorState extends BlogAppStates{
  final error;

  BlogAppSignOutErrorState(this.error);
}


class ChangeDrobDownMenuItemState extends BlogAppStates{}

class BlogAppUpdateBlogUserDataSuccessState extends BlogAppStates{}

class BlogAppFilterDataState extends BlogAppStates{}

class SendNotificationSuccessState extends BlogAppStates{}

class BlogAppBlockUserSuccessState extends BlogAppStates{}

class BlogAppBlockUserErrorState extends BlogAppStates{
  final error;

  BlogAppBlockUserErrorState(this.error);
}

class BlogAppLockProfileSuccessState extends BlogAppStates{}

class BlogAppLockProfileErrorState extends BlogAppStates{
  final error;

  BlogAppLockProfileErrorState(this.error);
}