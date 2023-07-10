abstract class BlogAppRegisterStates {}

class BlogAppRegisterInitialState extends BlogAppRegisterStates {}

class BlogAppRegisterLoadingState extends BlogAppRegisterStates {}

class BlogAppRegisterSuccessState extends BlogAppRegisterStates {}

class BlogAppRegisterErrorState extends BlogAppRegisterStates {
  final error;
  BlogAppRegisterErrorState(this.error);}

class BlogAppCreateUserSuccessState extends BlogAppRegisterStates {}

class BlogAppCreateUserErrorState extends BlogAppRegisterStates {
  final error;
  BlogAppCreateUserErrorState(this.error);}

class BlogAppRegisterChangeText extends BlogAppRegisterStates {}