import 'package:app/controllers/auth_module/auth_controller.dart';
import 'package:app/controllers/home_module/home_page.dart';
import 'package:app/ui/home_module/capacity_change_panel.dart';
import 'package:app/utils/app_colors.dart';
import 'package:app/utils/base_class.dart';
import 'package:app/utils/rounded_edge_button.dart';
import 'package:app/utils/sizes.dart';
import 'package:app/utils/skeleton_shapes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                print("icon clicked");
                Get.find<AuthController>().signOut();
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          color: lightAccent,
          onRefresh: () async => await controller.onInit(),
          child: Stack(alignment: Alignment.center, children: <Widget>[
            SlidingUpPanel(
              controller: controller.panelController,
              collapsed: Center(),
              defaultPanelState: PanelState.CLOSED,
              maxHeight: controller.panelHeightOpen,
              minHeight: controller.capacityChangeActive == false
                  ? 0
                  : (controller.firstTimePullUp
                      ? controller.panelHeightClosed
                      : 0),
              // onPanelClosed: controller.firstTimePullUp ? controller.selectedRestaurant=null : (){},
              backdropEnabled: true,
              panel: controller.capacityChangeActive
                  ? CapacityChangeView(
                      storeId: controller.capacityChangeStoreId!)
                  : Center(),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
              onPanelSlide: (double pos) => controller.onPanelSlide(pos),
              body: Container(
                color: lightAccent,
                child: Column(children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: darkPrimary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SingleChildScrollView(
                        controller: controller.scrollController,
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 25),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _getUserUI(controller),
                                      const Divider(),
                                      Center(
                                        child: Text(
                                          'Your Stores',
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                      ),
                                      const Divider(),
                                      _storeUI(controller),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
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

  Widget _getUserUI(HomePageController controller) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
                                border: Border.all(color: Colors.white)),
                            padding: const EdgeInsets.all(1),
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
                      // Positioned(
                      //   top: 6,
                      //   left: 6,
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     padding: const EdgeInsets.all(10),
                      //     decoration: const BoxDecoration(
                      //       gradient: LinearGradient(
                      //         begin: Alignment.topCenter,
                      //         end: Alignment.bottomCenter,
                      //         stops: [0.1, 0.7],
                      //         colors: [
                      //           Color.fromARGB(50, 0, 0, 0),
                      //           Color.fromARGB(50, 0, 0, 0),
                      //         ], // stops: [0.0, 0.1],
                      //       ),
                      //       shape: BoxShape.circle,
                      //     ),
                      //     height: 85,
                      //     width: 85,
                      //   ),
                      // ),
                      // const Positioned(
                      //     top: 35,
                      //     left: 35,
                      //     child: Icon(
                      //       Icons.edit,
                      //       color: Colors.white,
                      //     )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                controller.loading.value['user'] ?? true
                    ? ShimmerSkeleton(
                        enabled: controller.loading.value['user'] ?? true,
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
              ]),
          Column(
            children: [
              Row(
                children: [
                  controller.loading.value['user'] ?? true
                      ? const SizedBox.shrink()
                      : Text(
                          controller.user!.storeIds!.length.toString(),
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.store,
                    color: Colors.black,
                    size: 35,
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  controller.loading.value['user'] ?? true
                      ? const SizedBox.shrink()
                      : Text(
                          controller.daysSinceLastAccident(),
                          style: GoogleFonts.poppins(
                              color: controller.daysSinceLastAccident() ==
                                      "DANGER!"
                                  ? Colors.red
                                  : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: controller.daysSinceLastAccident() ==
                                      "DANGER!"
                                  ? 18
                                  : 12),
                        ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _storeUI(HomePageController controller) {
    return ShimmerSkeleton(
        enabled: (controller.loading.value['store'] ?? true),
        child: (controller.loading.value['store'] ?? true)
            ? ListView(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: List.generate(2, (i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SkeletonRect(
                          width: Get.size.width * 0.9,
                          height: Get.size.height * 0.5,
                          borderRadius: 20),
                      const SizedBox(
                        height: 15,
                      )
                    ],
                  );
                }),
              )
            : controller.storeList.isEmpty
                ? Text(
                    "No stores visible right now, please check again in a few minutes.",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: Get.size.width * 0.9,
                    height: Get.size.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.builder(
                      itemCount: controller.storeList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: Get.width,
                              height: Get.size.height * 0.1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '# of Customers:   ${controller.storeList[index].customerCount!}/${controller.storeList[index].capacity!}',
                                    style: GoogleFonts.poppins(
                                        color: controller.storeList[index]
                                                    .customerCount! <=
                                                controller
                                                    .storeList[index].capacity!
                                            ? Colors.black
                                            : Colors.red,
                                        fontWeight: controller.storeList[index]
                                                    .customerCount! <=
                                                controller
                                                    .storeList[index].capacity!
                                            ? FontWeight.w600
                                            : FontWeight.w900,
                                        fontSize: 12),
                                  ),
                                  RoundedEdgeButton(
                                      height: Sizes.HEIGHT_53,
                                      width: 75,
                                      color: darkAccent,
                                      borderColor: darkAccent,
                                      text: 'Reset',
                                      textColor: darkPrimary,
                                      textFontSize: Sizes.FONT_12,
                                      leftMargin: 5,
                                      rightMargin: 0,
                                      topMargin: 5,
                                      buttonRadius: Sizes.RADIUS_10,
                                      bottomMargin: Sizes.MARGIN_8,
                                      onPressed: (value) {
                                        controller.resetStoreNumCustomers(
                                            controller
                                                .storeList[index].storeId!);
                                      },
                                      context: context),
                                  RoundedEdgeButton(
                                      height: Sizes.HEIGHT_53,
                                      width: 120,
                                      color: darkAccent,
                                      borderColor: darkAccent,
                                      text: 'Change Limit',
                                      textColor: darkPrimary,
                                      textFontSize: Sizes.FONT_12,
                                      leftMargin: 5,
                                      rightMargin: 0,
                                      topMargin: 5,
                                      buttonRadius: Sizes.RADIUS_10,
                                      bottomMargin: Sizes.MARGIN_8,
                                      onPressed: (value) {
                                        controller.selectChangeCapacity(index);
                                      },
                                      context: context),
                                ],
                              ),
                            ),
                            Container(
                                width: Get.size.width * 0.9,
                                height: Get.size.height * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: skeletonGrey,
                                ),
                                child: WebView(
                                  initialUrl:
                                      controller.storeList[index].streamUrl ??
                                          'http://192.168.53.174:5000/camera',
                                  javascriptMode: JavascriptMode.unrestricted,
                                  onWebViewCreated:
                                      (WebViewController webViewController) {
                                    controller.webViewController
                                        .complete(webViewController);
                                  },
                                  onProgress: (int progress) {
                                    print(
                                        'WebView is loading (progress : $progress%)');
                                  },
                                  javascriptChannels: <JavascriptChannel>{
                                    controller
                                        .toasterJavascriptChannel(context),
                                  },
                                  navigationDelegate:
                                      (NavigationRequest request) {
                                    return NavigationDecision.navigate;
                                  },
                                  onPageStarted: (String url) {
                                    print('Page started loading: $url');
                                  },
                                  onPageFinished: (String url) {
                                    print('Page finished loading: $url');
                                  },
                                  gestureNavigationEnabled: true,
                                  backgroundColor: const Color(0x00000000),
                                )),
                            Container(
                              margin:
                                  const EdgeInsets.only(bottom: 10, top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'High Temp Times:',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ),
                                  controller.storeList[index].highTempTimes!
                                          .isEmpty
                                      ? Text(
                                          'No high temperatures, congrats!!',
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        )
                                      : ListView.builder(
                                          itemCount:
                                              controller.storeList.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (BuildContext context,
                                              int timeIndex) {
                                            return Container(
                                              width: Get.width,
                                              height: Get.size.height * 0.1,
                                              child: Text(
                                                DateFormat('yyyy-MM-dd hh:mm')
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            controller
                                                                    .storeList[
                                                                        index]
                                                                    .highTempTimes![
                                                                timeIndex])),
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                              ),
                                            );
                                          },
                                        ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ));
  }
}
