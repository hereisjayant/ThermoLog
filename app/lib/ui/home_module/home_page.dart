import 'package:app/controllers/home_module/home_page.dart';
import 'package:app/utils/app_colors.dart';
import 'package:app/utils/base_class.dart';
import 'package:app/utils/sizes.dart';
import 'package:app/utils/skeleton_shapes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget with BaseClass {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
      init: HomePageController(context: context),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          backgroundColor: lightAccent,
          elevation: Sizes.ELEVATION_0,
          leadingWidth: 100,
          title: Text(
            'ThermoLog',
            style: GoogleFonts.poppins(color: darkPrimary, fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          color: lightAccent,
          onRefresh: () async => await controller.onInit(),
          child: Stack(alignment: Alignment.center, children: <Widget>[
            Container(
              color: lightAccent,
              child: Column(children: [
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: darkPrimary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: SingleChildScrollView(
                      controller: controller.scrollController,
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                                child: _getProfilePicture(
                                                    controller),
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
                                            enabled: controller
                                                    .loading.value['user'] ??
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
                                          left: 40,
                                          right: 40,
                                          top: 9,
                                          bottom: 9),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  controller.loading
                                                              .value['user'] ??
                                                          true
                                                      ? SizedBox.shrink()
                                                      : Text(
                                                          controller.user!
                                                              .storeIds!.length
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                              ),
                            ),
                            SizedBox(
                              height: 180,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _getProfilePicture(HomePageController controller) {
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
}
