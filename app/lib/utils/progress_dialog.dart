import 'package:animate_do/animate_do.dart';
import 'package:app/utils/app_images.dart';
import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Roulette(
            infinite: true,

            child: Image(
              image: AssetImage(landing_page),
              height: 40,
              width: 40,
            ),
          ) /*CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
              primaryColor,
            ),
          )*/
          ,
        ),
      ),
    );
  }
}
