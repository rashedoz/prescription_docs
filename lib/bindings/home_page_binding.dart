import 'package:get/get.dart';
import 'package:prescription_document/controllers/firebase_controller.dart';
import 'package:prescription_document/controllers/home_controller/home_controller.dart';
import 'package:prescription_document/controllers/image_controller/image_picker_controller.dart';
import 'package:prescription_document/controllers/user_controller/user_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() async {
    //TODO: Dynamic User ID when Logged In
    Get.lazyPut(()=>HomeFirebaseController(),fenix: true);
    Get.put(HomeController());
    Get.lazyPut(()=>ImagePickerController());
    Get.lazyPut(()=>UserController(),fenix: true);

    // final sharedPreference = await SharedPreferences.getInstance();
    // Get.lazyPut(()=>sharedPreference);
    // Get.put(HomeController());
    // // Get.lazyPut(()=>ProductController());
    // Get.put(ProductController());
    // Get.lazyPut(() => CategoryController());
    // Get.lazyPut(() => CartRepository(preferences: Get.find()));
    // Get.lazyPut(() => CartController());
    // Get.put(CheckOutController());
    // Get.put(OrderListController());
    // Get.put(AuthController());

    // Get.lazyPut(() => StripePaymentController());
    // // Get.lazyPut(()=>CartController(cartRepo: Get.find()));
  }
}
