import 'package:get/get.dart';
import 'package:prescription_document/controllers/member_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() async {
    //TODO: Dynamic User ID
    Get.put(MemberController(userId: 'UID123'));

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
