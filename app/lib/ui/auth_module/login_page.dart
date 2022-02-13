import 'package:app/controllers/auth_module/auth_controller.dart';
import 'package:app/providers/user.dart';
import 'package:app/utils/app_colors.dart';
import 'package:app/utils/app_images.dart';
import 'package:app/utils/base_class.dart';
import 'package:app/utils/button_with_image.dart';
import 'package:app/utils/custom_label.dart';
import 'package:app/utils/progress_dialog.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetWidget<AuthController> with BaseClass {
  final UserProvider userProvider = UserProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(
          init: AuthController(),
          builder: (controller) => controller.loading.value
              ? Center(child: ProgressDialog())
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                child: Image(
                  image: AssetImage(landing_page),
                  height: Sizes.HEIGHT_218,
                  width: Sizes.WIDTH_226,
                ),
              ),
              SizedBox(
                height: Sizes.HEIGHT_42,
              ),
              CustomLabel(
                label: 'Welcome to ThermoLog!',
                labelColor: Colors.black,
                labelWeight: FontWeight.w700,
                labelSize: Sizes.FONT_18,
              ),
              SizedBox(
                height: Sizes.HEIGHT_10,
              ),
              CustomLabel(
                label: 'Store Safety in a Snap!',
                labelColor: Colors.black,
                labelWeight: FontWeight.w500,
                labelSize: Sizes.FONT_16,
              ),
              SizedBox(
                height: Sizes.HEIGHT_130,
              ),
              ButtonWithImage(
                height: Sizes.HEIGHT_53,
                color: darkAccent,
                text: 'Sign in with Google',
                textFontSize: Sizes.FONT_18,
                leftMargin: Sizes.MARGIN_16,
                rightMargin: Sizes.MARGIN_16,
                buttonRadius: Sizes.RADIUS_8,
                bottomMargin: Sizes.MARGIN_18,
                textFontWeight: FontWeight.w500,
                onPressed: (value) async {
                  controller.googleSignInMethod();
                },
                context: context,
                textColor: darkPrimary,
                prefixIcon: Image(
                  image: AssetImage(google),
                  height: Sizes.SIZE_24,
                  width: Sizes.SIZE_24,
                ),
              ),

            ],
          )),
    );
  }

}
