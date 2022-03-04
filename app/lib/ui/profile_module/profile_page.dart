import 'package:app/controllers/profile_module/profile_page.dart';
import 'package:app/utils/app_colors.dart';
import 'package:app/utils/app_images.dart';
import 'package:app/utils/base_class.dart';
import 'package:app/utils/sizes.dart';
import 'package:app/utils/skeleton_shapes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget with BaseClass {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin, BaseClass {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfilePageController>(
        init: ProfilePageController(),
        builder: (controller) => Scaffold(
            backgroundColor: lightHighlight,
            appBar: AppBar(
              backgroundColor: lightAccent,
              elevation: Sizes.ELEVATION_0,
              centerTitle: true,
              title: Text(
                "Profile",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
              actions: [
                Container(
                  width: 25,
                  height: 25,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        // Get.to(() => ProfileSideMenuPage());
                      },
                      child: Image(
                        image: AssetImage(side_menu_profile),
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            body: RefreshIndicator(
              color: darkPrimary,
              onRefresh: () async => await controller.onInit(),
              //onRefresh(context: context, destination: BottomBar()),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding:
                          const EdgeInsets.only(left: 16, top: 25),
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => EditProfilePage()),
                                // ).then((value) {
                                //   if (value != null) {
                                //     Get.snackbar(
                                //       "Saved",
                                //       "Your Profile Has Been Updated",
                                //       colorText: Colors.white,
                                //     );
                                //     controller.getCurrentUser(force: true);
                                //   }
                                // });
                              },
                              child: Stack(
                                  children: [
                                    Container(
                                      height: 95,
                                      width: 95,
                                      child: Container(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.white)),
                                          padding: EdgeInsets.all(1),
                                          child: _getProfilePicture(controller),
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 4.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 6,
                                      left: 6,
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: [0.1, 0.7],
                                            colors: [
                                              Color.fromARGB(50, 0, 0, 0),
                                              Color.fromARGB(50, 0, 0, 0),
                                            ], // stops: [0.0, 0.1],
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        height: 85,
                                        width: 85,
                                      ),
                                    ),
                                    const Positioned(
                                        top: 35,
                                        left: 35,
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ),

                            const SizedBox(
                              height: 5,
                            ),
                            controller.loading.value['user'] ?? true
                                ? ShimmerSkeleton(
                                    enabled: controller.loading.value['user'] ??
                                        true,
                                    child: SkeletonRect(
                                        width: Get.width * 0.2,
                                        height: 20,
                                        borderRadius: 5),
                                  )
                                : Text(
                                    controller.user!.name!,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                            // Text(
                            //   controller.userCity!,
                            //   style: GoogleFonts.poppins(
                            //       color: profileGrey,
                            //       fontWeight: FontWeight.w400,
                            //       fontSize: 16),
                            // ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 40, right: 40, top: 9, bottom: 9),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          controller.loading.value['user'] ??
                                                  true
                                              ? SizedBox.shrink()
                                              : Text(
                                                  controller
                                                      .user!.storeIds!.length
                                                      .toString(),
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18),
                                                ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Icon(
                                            Icons.store,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Stores',
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Divider(),
                          ],
                        ),
                      ),)
                    ],
                  ),
                ],
              ),
            )));
  }
}

Widget _getProfilePicture(ProfilePageController controller) {
  return controller.loading.value['user'] ?? true
      ? ShimmerSkeleton(
          enabled: controller.loading.value['user'] ?? true,
          child: SkeletonCircle(radius: 60))
      : CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(
            controller.user!.photoUrl!,
          ),
        );
}
