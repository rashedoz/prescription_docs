import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescription_document/common/app_colors.dart';
import 'package:prescription_document/common/widgets/common_app_button.dart';
import 'package:prescription_document/controllers/user_controller/user_controller.dart';
import 'package:prescription_document/views/auth/auth_screen.dart';
import 'package:prescription_document/views/home/home_page.dart';
import 'package:prescription_document/views/profile/user_profile.dart';

class CustomDrawer extends StatefulWidget {
  // final UserModel userModel;
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final userController = Get.find<UserController>();
  // String? appVersionText;
  // String? appVersion;
  // String? appBuildNumber;

  @override
  void initState() {
    super.initState();
    // _getDeviceInfo();

    // log('user image url :${Get.find<AuthController>().userData.value.avatarUrl}');
  }

  @override
  Widget build(BuildContext context) {
    var userdata = userController.getUserData();
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(15.0),
      )),
      child: Column(
        children: [
          Expanded(
            child: Column(
              // padding: EdgeInsets.zero,
              children: [
                Obx(() {
                  return userController.isLoggedIn.value
                      ? DrawerHeader(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).pop();
                              Get.to(() => UserProfilePage());
                              // Get.find<NavbarPageController>()
                              //     .getToProfilePage();
                            },
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.shade300,
                              child: Image.network(
                                userdata['image_url'] ??
                                    'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                              ),
                            ),
                            title: Text(
                              userdata['username'] ?? "",
                              // '${authController.userData.value.firstName ?? ''} ${authController.userData.value.lastName ?? ''}',
                              style: Get.theme.textTheme.headlineMedium
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                            ),
                            subtitle: Text(
                              'View Profile',
                              style: Get.theme.textTheme.headlineMedium
                                  ?.copyWith(
                                      color: Colors.white60,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                            ),
                          ),
                        )
                      : DrawerHeader(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                Get.to(() => const AuthScreen());
                              },
                              child: Text(
                                'No user data found\nPlease login ',
                                style: Get.theme.textTheme.headlineMedium
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white),
                              ),
                            ),
                          ),
                        );
                }),
                GetBuilder<UserController>(builder: (controller) {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          drawerItems('Home', () {
                            Navigator.of(context).pop();
                            Get.to(() => HomePage());
                            // Get.find<NavbarPageController>()
                            //     .getToHomePage(context);
                          },Icons.home),
                        ],
                      ),
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, bottom: 25, top: 10),
                  child: CommonAppButton(
                    onTapButton: userController.isLoggedIn.value
                        ? () {
                            // Log Out User
                            userController.logoutUser();
                            Navigator.of(context).pop();

                            log("Logged Out User");
                            Get.to(() => const AuthScreen());
                          }
                        : () {
                            Navigator.of(context).pop();
                            // Get.off(() => SignInPage());
                            Get.to(() => const AuthScreen());
                          },
                    btnContent:
                        userController.isLoggedIn.value ? 'Logout' : 'Login',
                    btnIcon: userController.isLoggedIn.value
                        ? Icons.logout
                        : Icons.login,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  drawerItems(String title, VoidCallback onTappingItem,IconData icon) {
    // drawerItems(String title, VoidCallback onTappingItem, {IconData? icon}) {
    return InkWell(
      onTap: onTappingItem,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                
                Icon(icon,size: 24,),     
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: Get.theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
