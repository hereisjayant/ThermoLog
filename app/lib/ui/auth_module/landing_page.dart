import 'package:app/ui/auth_module/login_page.dart';
import 'package:app/utils/app_images.dart';
import 'package:app/utils/base_class.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget with BaseClass {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            height: Sizes.HEIGHT_85,
          ),
          IconButton(
            onPressed: () async {
              pushToNextScreen(context: context, destination: LoginPage());
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: Sizes.HEIGHT_30,
            ),
          ),
        ],
      ),
    );
  }
}