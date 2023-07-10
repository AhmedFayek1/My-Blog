abstract class BlogAppLoginStates {}

class BlogAppLoginInitialState extends BlogAppLoginStates {}

class BlogAppLoginLoadingState extends BlogAppLoginStates {}

class BlogAppLoginSuccessState extends BlogAppLoginStates {
  final String uID;

  BlogAppLoginSuccessState(this.uID);
}

class BlogAppLoginErrorState extends BlogAppLoginStates {
  final error;
  BlogAppLoginErrorState(this.error);}

class BlogAppLoginChangeText extends BlogAppLoginStates {}

class BlogAppLoginSignOutState extends BlogAppLoginStates {}