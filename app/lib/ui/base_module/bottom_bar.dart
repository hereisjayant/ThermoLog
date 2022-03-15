import 'package:app/controllers/auth_module/auth_controller.dart';
import 'package:app/controllers/base_module/bottom_bar_controller.dart';
import 'package:app/ui/auth_module/landing_page.dart';
import 'package:app/ui/home_module/home_page.dart';
import 'package:app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(Get.find<AuthController>().user == null ? false : true);
    print(Get.find<AuthController>().checkUser == null ? false : true);

    return ((Get.find<AuthController>().user == null) &&
        (Get.find<AuthController>().checkUser == null))
        ? LandingPage()
        : GetBuilder<BottomBarController>(
      init: BottomBarController(),
      builder: (controller) => Scaffold(
        body: Stack(
          children: <Widget>[
            controller.currentScreen!,
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: AnimatedContainer(
                child: HomePage(),
                duration: Duration(milliseconds: 250),
                height: controller.clickedCentreFAB
                    ? MediaQuery.of(context).size.height
                    : 0,
                width: controller.clickedCentreFAB
                    ? MediaQuery.of(context).size.height
                    : 0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        controller.clickedCentreFAB ? 0.0 : 300.0),
                    color: badgeColor),
              ),
            )
          ],
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        floatingActionButton: controller.isFABVisible
            ? FloatingActionButton(
          backgroundColor: badgeColor,
          onPressed: () {
            controller.toggleButton();
          },
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: controller.clickedCentreFAB
                ? Icon(Icons.close)
                : Icon(Icons.add),
          ),
          elevation: 10.0,
        )
            : null,
        bottomNavigationBar: bottomBar(),
      ),
    );
  }

  Widget bottomBar() {
    return GetBuilder<BottomBarController>(
      init: BottomBarController(),
      builder: (controller) => BottomAppBar(
        elevation: 6,
        child: Container(
          margin: EdgeInsets.only(top: 5, bottom: 5, left: 12.0, right: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                tooltip: 'Home',
                //update the bottom app bar view each time an item is clicked
                onPressed: () {
                  if (controller.clickedCentreFAB) controller.toggleButton();
                  controller.changeSelectedValue(0);
                  controller.displayFAB(true);
                },
                iconSize: 30.0,
                icon: Icon(
                  Icons.home,
                  //darken the icon if it is selected or else give it a different color
                  color: controller.navigatorValue == 0 &&
                      !controller.clickedCentreFAB
                      ? badgeColor
                      : Colors.grey.shade400,
                ),
              ),
              //to leave space in between the bottom app bar items and below the FAB
              controller.isFABVisible
                  ? const SizedBox(
                width: 50.0,
              )
                  : IconButton(
                  tooltip: 'Stream',
                  onPressed: () {
                    controller.toggleButton();
                  },
                  iconSize: 27.0,
                  icon: controller.clickedCentreFAB
                      ? Icon(
                    Icons.close_outlined,
                    color: badgeColor,
                  )
                      : Icon(
                    Icons.stream,
                    color: Colors.grey.shade400,
                  )),
              IconButton(
                tooltip: 'Profile',
                onPressed: () {
                  if (controller.clickedCentreFAB) controller.toggleButton();
                  controller.changeSelectedValue(2);
                  controller.displayFAB(true);
                },
                iconSize: 27.0,
                icon: Icon(
                  Icons.person,
                  //darken the icon if it is selected or else give it a different color
                  color: controller.navigatorValue == 0 &&
                      !controller.clickedCentreFAB
                      ? badgeColor
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
        //to add a space between the FAB and BottomAppBar
        shape: CircularNotchedRectangle(),
        //color of the BottomAppBar
        color: Colors.white,
      ),
    );
  }
}