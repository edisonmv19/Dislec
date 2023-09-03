import 'package:dislec/src/ui/pages/home/mult_Question.dart';
import 'package:dislec/src/ui/pages/home/accu_Question.dart';
import 'package:dislec/src/ui/pages/home/home.dart';
import 'package:dislec/src/ui/pages/home/register.dart';
import 'package:dislec/src/ui/pages/home/registerEst.dart';
import 'package:dislec/src/ui/pages/home/results.dart';
import 'package:dislec/src/ui/pages/home/sec1.dart';
import 'package:dislec/src/ui/pages/home/sec2.dart';
import 'package:dislec/src/ui/pages/home/sec3.dart';
import 'package:dislec/src/ui/pages/home/speed_Question.dart';
import 'package:dislec/src/ui/pages/home/speed_QuestionCon.dart';
import 'package:dislec/src/ui/pages/sign_in/sign_in_binding.dart';
import 'package:dislec/src/ui/pages/sign_in/sign_in_page.dart';
import 'package:dislec/src/ui/pages/splash/splash_binding.dart';
import 'package:dislec/src/ui/pages/splash/splash_page.dart';
import 'package:dislec/src/ui/routes/route_names.dart';
import 'package:get/get.dart';

class RoutePages {
  const RoutePages._();

  static List<GetPage<dynamic>> get all {
    return [
      GetPage(
        name: RouteNames.home,
        page: () => const HomePage(),
      ),
      GetPage(
        name: RouteNames.est,
        page: () => const RegisterEst(),
      ),
      GetPage(
        name: RouteNames.sec1,
        page: () => const Section1(),
      ),
      GetPage(
        name: RouteNames.sec2,
        page: () => const Section2(),
      ),
      GetPage(
        name: RouteNames.sec3,
        page: () => const Section3(),
      ),
      GetPage(
        name: RouteNames.accu,
        page: () => const QuestionAccu(),
      ),
      GetPage(
        name: RouteNames.speed,
        page: () => const QuestionSpeed(),
      ),
      GetPage(
        name: RouteNames.speed2,
        page: () => const QuestionSpeedCon(),
      ),
      GetPage(
        name: RouteNames.result,
        page: () => const Result(),
      ),
      GetPage(
        name: RouteNames.register,
        page: () => const RegisterPage(),
      ),
      GetPage(
        name: RouteNames.mult,
        page: () => const QuestionMult(),
      ),
      GetPage(
        name: RouteNames.signIn,
        page: () => const SignInPage(),
        binding: const SignInBinding(),
      ),
      GetPage(
        name: RouteNames.splash,
        page: () => const SplashPage(),
        binding: const SplashBinding(),
      ),
    ];
  }
}
