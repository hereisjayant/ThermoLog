// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:app/controllers/base_module/local_storage_data.dart';
import 'package:app/models/user.dart';
import 'package:app/providers/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class EditProfileController extends GetxController {
  // static EditProfileController instance = Get.find();

  final LocalStorageData localStorageData = Get.find<LocalStorageData>();

  final UserProvider userProvider = UserProvider();
  firebase_storage.Reference _storageReference = firebase_storage
      .FirebaseStorage.instance
      .ref()
      .child('${DateTime.now().millisecondsSinceEpoch}');

  ValueNotifier<bool> get loading => _loading;
  ValueNotifier<bool> _loading = ValueNotifier(false);

  File? get image => _image;
  File? _image;

  User? get user => _user;
  User? _user;

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController bioController = TextEditingController();

  String? get photoController => _photoController;
  String? _photoController;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getCurrentUser().then((value) async {
      await setInitialControllers();
    });
    // await setInitialControllers();
  }

  //updates the DyneUser in users collection
  Future<void> updateUser({
    String? userId,
    String? notificationToken,
    String? email,
    String? name,
    String? phone,
    String? photoUrl,
    int? lastTime,
    int? safeTime,
    List<dynamic>? storeIds,
  }) async {
    await userProvider
        .userUpdate(
      userId: userId ?? _user!.userId!,
      notificationToken: notificationToken,
      email: email,
      name: name ?? nameController.text,
      phone: phone ?? phoneController.text,
      photoUrl: photoUrl ?? _photoController!,
      lastTime: lastTime,
      safeTime: safeTime,
      storeIds: storeIds,
    )
        .then((user) async {
      _user = user!;
      await localStorageData.setUser(_user!);
      update();
    });
  }

  Future getCurrentUser() async {
    try {
      _loading.value = true;
      User? user = await localStorageData.getUser();
      _user = user;
      update();
    } on Exception catch (e) {
      print(e.toString());
    }
  }


  Future setInitialControllers() async {
    nameController.text = user!.name!;
    phoneController.text = user!.phone!.toString();
    _photoController = user!.photoUrl!;
    update();
    _loading.value = false;

    update();
  }

  Future chooseImage(String type) async {
    await pickImage(type).then((selectedImage) async {
      await compressImage().then((value) async {
        await uploadImageToStorage();
      });
    });
    update();
  }

  Future pickImage(String action) async {
    PickedFile selectedImage;
    final picker = ImagePicker();
    action == 'Gallery'
        ? selectedImage = (await picker.getImage(source: ImageSource.gallery))!
        : selectedImage = (await picker.getImage(source: ImageSource.camera))!;
    _image = File(selectedImage.path);
    update();
  }

  Future compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    // final path = "tempDir.path";
    int rand = Random().nextInt(10000);

    Im.Image? image = Im.decodeImage(this.image!.readAsBytesSync());
    Im.copyResize(image!, width: 25, height: 25);
    File newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
    this._image = newim2;
    print('done');
    update();
  }

  Future<void> uploadImageToStorage() async {
    await _storageReference
        .putFile(image!)
        .then((value) => value.ref.getDownloadURL())
        .then((url) {
      _photoController = url;
      update();
    });
  }
}
