import 'dart:convert';

import 'package:app/models/user.dart';
import 'package:app/providers/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageData extends GetxController {
  static LocalStorageData instance = Get.find<LocalStorageData>();
  final userProvider = UserProvider();

  ValueNotifier<bool> get loading => _loading;
  ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    _loading.value = true;
    super.onInit();
    await getUser();
    _loading.value = false;
    update();
  }
  /*Rxn<DyneUser>*/
  // var dyneUser = Rxn<DyneUser>();

  Future<User?>? getUser() async {
    try {
      User? user = await _getUserData();
      if (user == null) {
        return null;
      }
      user.lastTime = DateTime.now().millisecondsSinceEpoch;

      userProvider.userUpdate(
          userId: user.userId!,
          lastTime: DateTime.now().millisecondsSinceEpoch);
      // this.dyneUser.value = dyneUser;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString('user');
    return User.fromJson(json.decode(value!));
  }

  Future<void> setUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(user.toJson())).then((value) {
      // this.dyneUser.value = dyneUser;
    });
  }

  Future<void> deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', "");
    // await prefs.setString('viewed_tooltips', "");

    // await prefs.clear();
  }

  checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user') != null;
  }


}
