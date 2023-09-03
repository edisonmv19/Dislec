import 'package:dislec/src/app/controllers/auth_controller.dart';
import 'package:dislec/src/ui/pages/splash/splash_controller.dart';
import 'package:get/get.dart';

class SplashBinding implements Bindings {
  const SplashBinding();

  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(authController: Get.find<AuthController>()),
    );
  }
}
