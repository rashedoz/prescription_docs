import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:prescription_document/common/app_colors.dart';
import 'package:prescription_document/common/widgets/common_app_button.dart';
import 'package:prescription_document/controllers/firebase_controller.dart';
import 'package:prescription_document/controllers/home_controller/home_controller.dart';
import 'package:prescription_document/controllers/user_controller/user_controller.dart';
import 'package:prescription_document/models/member_model.dart';
import 'package:prescription_document/views/auth/auth_screen.dart';
import 'package:prescription_document/views/visits/visits_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeFirebaseController memberController =
        Get.find<HomeFirebaseController>();

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home'),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            GetBuilder<UserController>(builder: (userController) {
              var userData = userController.getUserData();
              // userController.getUserData();
              return userController.isUserLoading.value
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => const AuthScreen());
                            },
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundImage:
                                  NetworkImage(userData['image_url']),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi, ${userData['username']} 👋',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Text(
                                //   'User Role',
                                //   style: TextStyle(
                                //       color: Colors.black45,
                                //       fontSize: 13,
                                //       fontWeight: FontWeight.bold),
                                // )
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.notifications,
                              color: AppColors.primaryColor,
                              size: 30,
                            ),
                            onPressed: () {
                              // Add your logic for the settings icon here
                            },
                          ),
                        ],
                      ),
                    );
            }),
            // Expanded(
            //   child: Obx(() {
            //     if (memberController.members.isEmpty) {
            //       return Center(child: Text('No members found.'));
            //     }
            //     return GridView.builder(
            //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 2, // Number of columns
            //         crossAxisSpacing: 10, // Horizontal space between items
            //         mainAxisSpacing: 10, // Vertical space between items
            //       ),
            //       itemCount: memberController.members.length,
            //       itemBuilder: (context, index) {
            //         // Access the member model
            //         MemberModel member = memberController.members[index];
            //         return Card(
            //           // Implement your member card
            //           child: Text(member.name),
            //         );
            //       },
            //     );
            //   }),
            // ),

            Expanded(
              child: Obx(() {
                // if (memberController.members.isEmpty) {
                //   return const Center(child: Text('No members found.'));
                // }

                return GridView.custom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  gridDelegate: SliverWovenGridDelegate.count(
                    pattern: [
                      const WovenGridTile(0.9),
                      const WovenGridTile(
                        7 / 7,
                        // crossAxisRatio: 0.9,
                        // alignment: AlignmentDirectional.centerStart,
                      ),
                    ],
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                    childCount: memberController.members.length + 1,
                    (context, index) {
                      if (index < memberController.members.length) {
                        return MemberWidget(
                          member: memberController.members[index],
                          index: index,
                        );
                      } else {
                        return const AddFamilyMemberButton();
                      }
                    },
                  ),
                );
                // GridView.builder(
                //   padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16),
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     crossAxisSpacing: 16,
                //     mainAxisSpacing: 16,
                //     childAspectRatio: 2,
                //   ),
                //   itemCount: memberController.members.length +
                //       1, // Add one for the 'Add' button
                //   itemBuilder: (context, index) {
                //     if (index < memberController.members.length) {
                //       return MemberWidget(
                //           member: memberController.members[index]);
                //     } else {
                //       return const AddFamilyMemberButton();
                //     }
                //   },
                // );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: CommonAppButton(
                onTapButton: () {},
                btnContent: 'Upload Prescription/Report',
                btnIcon: Icons.cloud_upload_sharp,
              ),
            )
          ],
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Navigate to the MemberDetailsPage
      //     Get.to(() => const MemberDetailsPage());
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

class MemberWidget extends StatelessWidget {
  final MemberModel member;
  final int index;

  const MemberWidget({Key? key, required this.member, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // bool isSelected;
    return GetBuilder<HomeController>(builder: (controller) {
      bool isSelected = controller.selectedIndex.value == index;
      return InkWell(
        onTap: () {
          Get.find<HomeController>().selectedPatient(index);

          log('Going to ${member.name} page');
          Get.to(() => VisitsPage(member: member));
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(member.imageData),
                backgroundColor: Colors.transparent,
              ),
              // const Icon(Icons.person), // Replace with actual data
              Text(
                member.name,
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ), // Replace with actual data
              // Age from birthdate, Format and show birthdate("2023-11-18 00:00:00.000") string as DD/MM/YYYY

              // Text(
              //   "Birth Date: ${member.bithDate}",
              //   // Text decoration small and italic
              //   style: const TextStyle(
              //     fontSize: 12,
              //     fontStyle: FontStyle.italic,
              //   ),
              // ), // Replace with actual data
            ],
          ),
        ),
      );
    });
  }
}

class AddFamilyMemberButton extends StatelessWidget {
  const AddFamilyMemberButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.find<HomeController>().addUser(context);
        // Get.toNamed('/add-member');
        // Logic to add a new family member
        // addUser();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
