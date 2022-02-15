import 'package:app/controllers/profile_module/edit_profile_controller.dart';
import 'package:app/ui/auth_module/account_success_page.dart';
import 'package:app/utils/app_colors.dart';
import 'package:app/utils/app_images.dart';
import 'package:app/utils/base_class.dart';
import 'package:app/utils/progress_dialog.dart';
import 'package:app/utils/rounded_edge_button.dart';
import 'package:app/utils/sizes.dart';
import 'package:app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAccountPage extends GetWidget<EditProfileController>
    with BaseClass {
  final FocusNode _displayNameNode = FocusNode();
  final FocusNode _phoneNumberNode = FocusNode();
  final GlobalKey<FormState> createProfileKey = GlobalKey<FormState>();
  final editingController = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
        init: Get.find<EditProfileController>(),
        builder: (controller) => controller.loading.value
            ? Scaffold(
            backgroundColor: darkPrimary, body: Center(child: ProgressDialog()))
            : Scaffold(
            backgroundColor: darkPrimary,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: lightAccent,
              elevation: Sizes.ELEVATION_0,
              title: Text(
                'Create Account',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: Form(
              key: createProfileKey,
              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 25),
                        child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: Container(
                            height: 130,
                            width: 130,
                            child: Stack(
                              children: [
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      _showPicker(context);
                                    },
                                    child: CircleAvatar(
                                      radius: 70,
                                      backgroundColor: Colors.white,
                                      child: controller.photoController !=
                                          null
                                          ? Container(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.white)),
                                          padding: EdgeInsets.all(1),
                                          child: CircleAvatar(
                                            radius: 65,
                                            backgroundImage:
                                            NetworkImage(
                                              controller
                                                  .photoController!,
                                            ),
                                          ),
                                        ),
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: new Border.all(
                                            color: Colors.white,
                                            width: 4.0,
                                          ),
                                        ),
                                      )
                                          : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                            BorderRadius.circular(
                                                50)),
                                        width: 100,
                                        height: 100,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Image(
                                    image: AssetImage(camera),
                                    height: 30,
                                    width: 30,
                                    color: lightAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 36,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 25, right: 25),
                            child: TextFormField(
                              focusNode: _displayNameNode,
                              decoration: InputDecoration(
                                labelText: 'Display Name',
                              ),
                              controller: controller.nameController,
                              onSaved: (value) => controller
                                  .nameController.text = value!.trim(),
                              onChanged: (value) => null,
                              validator: Validator().name,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 25, right: 25),
                            child: TextFormField(
                              focusNode: _phoneNumberNode,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                              ),
                              controller: controller.phoneController,
                              onSaved: (value) =>
                              controller.phoneController.text = value!.trim(),
                              onChanged: (value) => null,
                              validator: Validator().number,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 200,),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RoundedEdgeButton(
                          height: Sizes.HEIGHT_53,
                          color: lightAccent,
                          text: 'Continue',
                          textFontSize: 18,
                          leftMargin: 16,
                          rightMargin: 16,
                          buttonRadius: 10,
                          bottomMargin: 64,
                          onPressed: (value) {
                            if (createProfileKey.currentState!.validate()) {
                              SystemChannels.textInput.invokeMethod(
                                  'TextInput.hide'); //to hide the keybo
                              controller.updateUser(
                                  userId: controller.user!.userId!,
                                  photoUrl: controller.photoController,
                                  name: controller
                                      .nameController.value.text,
                                  email:
                                  controller.emailController.value.text,
                                  phone:
                                  controller.phoneController.value.text);
                              pushToNextScreenWithAnimation(
                                  context: context,
                                  destination: AccountSuccessPage());
                            }
                          },
                          context: context),
                    ),
                  ]
              ),
            )));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                   ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: const Text('Camera'),
                      onTap: () {
                        // Get.find<EditProfileController>()
                        //     .chooseImage('Camera')
                        //     .then((v) {
                        //   popToPreviousScreen(context: context);
                        // });
                      }),
                  ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      // Get.find<EditProfileController>()
                      //     .chooseImage('Gallery')
                      //     .then((v) {
                      //   popToPreviousScreen(context: context);
                      // });
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

}
