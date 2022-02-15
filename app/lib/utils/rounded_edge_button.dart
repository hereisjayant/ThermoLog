import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedEdgeButton extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final String? text;
  final Color? textColor;
  final FontWeight textFontWeight;
  final double textFontSize;
  final Function onPressed;
  final double buttonRadius;
  final double leftMargin;
  final double rightMargin;
  final double topMargin;
  final double bottomMargin;
  final BuildContext context;
  final double buttonElevation;
  final Color borderColor;
  final bool isAddFriend;

  RoundedEdgeButton(
      {required this.height,
        this.width = double.infinity,
        required this.color,
        required this.text,
        this.textColor,
        this.textFontWeight = FontWeight.bold,
        required this.textFontSize,
        required this.onPressed,
        this.buttonRadius = 0,
        this.leftMargin = 0,
        this.rightMargin = 0,
        this.topMargin = 0,
        this.bottomMargin = 0,
        this.buttonElevation = 0,
        this.borderColor = Colors.transparent,
        this.isAddFriend = false,
        required this.context})
      : assert(
  text != null,
  'A non-null String must be provided to a Text widget.',
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(
          left: leftMargin,
          right: rightMargin,
          top: topMargin,
          bottom: bottomMargin),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(buttonRadius),
      ),
      child: ElevatedButton(
        child: isAddFriend
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_rounded,
              color: Colors.white,
              size: 35,
            ),
            SizedBox(width: 5,),
            Text(
              text!,
              style: GoogleFonts.poppins(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: textFontSize,
              ),
            ),
          ],
        )
            : Text(text!,
            style: GoogleFonts.poppins(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: textFontSize,
            )),
        onPressed: () {
          onPressed(context);
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          primary: color,
        ),
      ),
    );
  }
}
