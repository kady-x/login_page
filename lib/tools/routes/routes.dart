import 'package:login_page/screens/auth/resetpassword/reset.dart';
import '../../screens/auth/forgetpassword/forget.dart';
import '../../screens/auth/verifycode/verifycode.dart';
import '../../screens/auth/signup/signup.dart';
import '../../screens/auth/signin/signin.dart';
import '../../screens/profile/profile.dart';
import 'package:get/get.dart';
import 'app_route.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: "/", page: () => const Profile()),
  GetPage(name: AppRoute.signin, page: () => const SignIn()),
  GetPage(name: AppRoute.signup, page: () => const SignUp()),
  GetPage(name: AppRoute.forGetPassword, page: () => const Forget()),
  GetPage(name: AppRoute.resetPassword, page: () => const Reset()),
  GetPage(name: AppRoute.verifyCode, page: () => const VerifyCode(email: '')),
];
