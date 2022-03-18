import 'package:app/controllers/auth_module/auth_controller.dart';
import 'package:app/controllers/base_module/local_storage_data.dart';
import 'package:app/models/store.dart';
import 'package:app/models/user.dart' as appuser;
import 'package:app/providers/store.dart';
import 'package:app/providers/user.dart';
import 'package:app/ui/auth_module/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class HomePageController extends GetxController {
  final BuildContext? context;

  HomePageController({this.context});

  final LocalStorageData localStorageData = Get.find();

  final userProvider = UserProvider();
  final storeProvider = StoreProvider();

  ValueNotifier<Map<String, bool>> get loading => _loading;
  ValueNotifier<Map<String, bool>> _loading = ValueNotifier(<String, bool>{
    'user': true,
    'store': true,
    'nullUser': true,
  });

  appuser.User? get user => _user;
  appuser.User? _user;

  bool? get hasNotifs => _hasNotifs;
  bool? _hasNotifs;

  List<Store> get storeList => _storeList;
  List<Store> _storeList = [];

  ScrollController get scrollController => _scrollController;
  ScrollController _scrollController = new ScrollController();

  @override
  Future<void> onInit() async {
    super.onInit();
    _loading = ValueNotifier(<String, bool>{
      'user': true,
      'nullUser': true,
      'store': true,
    });
    update();
    _storeList = [];
    await nullUserCheck(); // we load as much as possible beforehand assuming the user is probably authenticated
    await getCurrentUser();
    getStores();
  }

  Future getCurrentUser({bool? force = false}) async {
    if (force == true) {
      _user = await userProvider.userByEmailOrId(
          email: Get.find<AuthController>().user);
      await localStorageData.setUser(_user!);
      update();
    }
    appuser.User? value = await localStorageData.getUser();
    if (value == null) {
      _user = await userProvider.userByEmailOrId(
          email: Get.find<AuthController>().user ?? "priahi12@gmail.com");
    } else {
      _user = value;
    }
    Map<String, bool> load = {..._loading.value};
    load['user'] = false;
    _loading.value = load;
  }

  Future getStores({int? limit = 30}) async {
    for (var storeId in _user!.storeIds!) {
      storeProvider.storeById(storeId).then((value) {
        _storeList.add(value);
        update();
      });
    }
    Map<String, bool> load = {..._loading.value};
    load['store'] = false;
    _loading.value = load;
    update();
  }

  Store getStore(String? storeId) {
    return _storeList.firstWhere((element) => element.storeId == storeId);
  }

  Future<void> nullUserCheck() async {
    if (_user == null) {
      FirebaseAuth.instance.signOut();
      await localStorageData.deleteUser();
      Get.offAll(() => LoginPage());
    }
    Map<String, bool> load = {..._loading.value};
    load['nullUser'] = false;
    _loading.value = load;
  }
}
