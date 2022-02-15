import 'package:app/controllers/home_module/home_page.dart';
import 'package:app/utils/app_colors.dart';
import 'package:app/utils/base_class.dart';
import 'package:app/utils/sizes.dart';
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


}
