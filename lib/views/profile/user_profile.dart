import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescription_document/common/app_colors.dart';
import 'package:prescription_document/controllers/user_controller/user_controller.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    var userData = userController.getUserData();
    // Get.find<OrderListController>().getOrderList();

    return Scaffold(
      body: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Column(
                    children: [
                      Container(
                        height: 300,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        child: userController.isLoggedIn.value
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  _userImageView(userData['image_url']),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    // '${authController.userData.value.firstName ?? ''} ${authController.userData.value.lastName ?? ''}',
                                    // 'Rokon Rahman',
                                    userData['username'] ??
                                        "",
                                    // controller.user?.name ?? "N/A",
                                    style: Get.textTheme.headlineLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  
                                  userData['email'] != null &&
                                          userData['email'] !=
                                              ''
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.email_outlined,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              userData['email'] ??
                                                  '',
                                              // 'rokon@gmail.com',
                                              // controller.userData.value?.email ?? "N/A",
                                              style: Get.textTheme.bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ],
                              )
                            : Center(
                                child: Text(
                                  'No user data found\nPlease login ',
                                  style: Get.theme.textTheme.headlineMedium
                                      ?.copyWith(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15),
                                ),
                              ),
                      ),
                      
                    ],
                  ),
                ),
                Expanded(
                    child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                   
                    _profilePageItemList(Icons.logout_rounded, 'Logout', () {
                      userController.logoutUser();
                    }),

                    // authController.isLoggedIn.value
                    //     ? _profilePageItemList(Icons.person, 'Edit Profile',
                    //         () => Get.to(() => const EditProfilePage()))
                    //     : Container(),

                    // _profilePageItemList(Icons.location_on_outlined, 'Manage Address',
                    //     () => Get.to(() => const ManageAddressPage())),
                    // _profilePageItemList(Icons.password_outlined, 'Change Password',
                    //     () => Get.to(() => const ChangePassword())),

                    // _profilePageItemList(Icons.logout, 'Logout',
                    //     () => Get.to(() => const SignInPage())),
                  ],
                ))
              ],
            )
          
    );
  }

  Widget _userImageView(String imgURL) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: NetworkImage(imgURL),
    );
  }

  Widget _cardItem(String itemName, IconData iconItem, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            iconItem,
            size: 30,
          ),
          // Stack(
          //   clipBehavior: Clip.none,
          //   children: [
          //     SizedBox(
          //       height: ResponsiveUtils.height30 + 6,
          //       child: Icon(
          //         iconItem,
          //         size: 30,
          //       ),
          //     ),
          //     // Positioned(
          //     //   right: 0,
          //     //   top: -3,
          //     //   child: Container(
          //     //     decoration: BoxDecoration(
          //     //         borderRadius: BorderRadius.circular(6),
          //     //         color: AppColors.mainColor),
          //     //     child: Padding(
          //     //       padding: const EdgeInsets.symmetric(
          //     //           vertical: 2.0, horizontal: 4),
          //     //       child: Text(
          //     //         itemCount.toString(),
          //     //         style: Get.theme.textTheme.bodySmall!.copyWith(
          //     //             color: Colors.white,
          //     //             fontSize: 10,
          //     //             fontWeight: FontWeight.w600),
          //     //       ),
          //     //     ),
          //     //   ),
          //     // )
          //   ],
          // ),
          Text(
            itemName,
            style: Get.theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500, fontSize: 15),
          )
        ],
      ),
    );

    // return InkWell(
    //   onTap: onTap,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: [
    //       Icon(
    //         iconItem,
    //         size: 30,
    //       ),
    //       Text(
    //         itemName,
    //         style: Get.theme.textTheme.bodyMedium!
    //             .copyWith(fontWeight: FontWeight.w500, fontSize: 15),
    //       )
    //     ],
    //   ),
    // );
  }

  // Stack(
  Widget _profilePageItemList(
      IconData iconData, String itemName, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  iconData,
                  size: 25,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(
                    itemName,
                    style: Get.theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
           Divider(
            color: const Color.fromARGB(255, 208, 203, 238),
            thickness: 1.5,
          )
        ],
      ),
    );
  }
}
