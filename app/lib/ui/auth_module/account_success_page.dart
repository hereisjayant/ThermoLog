import 'package:app/ui/home_module/home_page.dart';
import 'package:app/utils/app_colors.dart';
import 'package:app/utils/base_class.dart';
import 'package:app/utils/custom_label.dart';
import 'package:app/utils/rounded_edge_button.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AccountSuccessPage extends StatelessWidget with BaseClass {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightAccent,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.only(top: Sizes.HEIGHT_100),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Sizes.SIZE_24),
            topRight: Radius.circular(Sizes.SIZE_24),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: Sizes.HEIGHT_130,
                ),
                CustomLabel(
                  textAlign: TextAlign.center,
                  label: 'Account Created\nSuccessfully',
                  labelColor: Colors.black,
                  labelSize: Sizes.FONT_24,
                  labelWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: Sizes.HEIGHT_20,
                ),
                Container(
                  height: Sizes.HEIGHT_220,
                  width: Sizes.WIDTH_220,
                  color: Colors.white,
                  child: const RiveAnimation.asset(
                    'assets/rive_items/check.riv',
                    fit: BoxFit.cover,
                  ),
                ),
                /*Container(
                  margin: EdgeInsets.only(right: 50),
                  child: Image(
                    image: AssetImage(account_created),
                  ),
                ),*/
              ],
            ),
            RoundedEdgeButton(
                height: Sizes.HEIGHT_53,
                color: lightAccent,
                text: 'Continue',
                textFontSize: 18,
                leftMargin: 16,
                rightMargin: 16,
                buttonRadius: 10,
                bottomMargin: 80,
                onPressed: (value) {
                  pushReplaceAndClearStack(
                      context: context, destination: HomePage());
                },
                context: context),
          ],
        ),
      ),
    );
  }
}
