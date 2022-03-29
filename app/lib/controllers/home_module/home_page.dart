import 'dart:async';
import 'dart:io';

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
import 'package:neat_periodic_task/neat_periodic_task.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePageController extends GetxController {
  final BuildContext? context;

  HomePageController({this.context});

  final LocalStorageData localStorageData = Get.find();

  double panelHeightOpen = 200.0;
  double panelHeightClosed = 100.0;
  final double initFabHeight = 0.0;
  double? fabHeight;
  PanelController panelController = new PanelController();
  bool capacityChangeActive = false;
  String? capacityChangeStoreId;
  int? currCapacity;
  bool firstTimePullUp = false;

  final userProvider = UserProvider();
  final storeProvider = StoreProvider();

  ValueNotifier<Map<String, bool>> get loading => _loading;
  ValueNotifier<Map<String, bool>> _loading = ValueNotifier(<String, bool>{
    'user': true,
    'store': true,
    'nullUser': true,
  });
  final Completer<WebViewController> webViewController =
      Completer<WebViewController>();

  appuser.User? get user => _user;
  appuser.User? _user;

  bool? get hasNotifs => _hasNotifs;
  bool? _hasNotifs;

  List<Store> get storeList => _storeList;
  List<Store> _storeList = [];

  ScrollController get scrollController => _scrollController;
  ScrollController _scrollController = new ScrollController();
  NeatPeriodicTaskScheduler? currentFetchDataScheduler;

  @override
  Future<void> onInit() async {
    super.onInit();
    WebView.platform = AndroidWebView();
    _loading = ValueNotifier(<String, bool>{
      'user': true,
      'nullUser': true,
      'store': true,
    });
    update();
    _storeList = [];
    update();
    await getCurrentUser();
    await nullUserCheck(); // we load as much as possible beforehand assuming the user is probably authenticated
    getStores();
    update();
    periodicTaskForGetCurrentTemps();
  }

  @override
  void dispose() {
    super.dispose();
    currentFetchDataScheduler!.stop();
  }

  /// Run periodic call function for get current data of user and stores from provider
  void periodicTaskForGetCurrentTemps() async {
    currentFetchDataScheduler = NeatPeriodicTaskScheduler(
      interval: const Duration(seconds: 9),
      name: 'GetCurrentTempFromProvider',
      timeout: const Duration(seconds: 5),
      task: () async {
        getCurrentUser(force: true);
        getStores(isRefresh: true);
        update();
      },
      minCycle: const Duration(seconds: 4),
    );

    currentFetchDataScheduler!.start();
    await ProcessSignal.sigterm.watch().first;
    await currentFetchDataScheduler!.stop();
  }

  JavascriptChannel toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
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
          email: Get.find<AuthController>().user);
    } else {
      _user = value;
    }
    Map<String, bool> load = {..._loading.value};
    load['user'] = false;
    _loading.value = load;
  }

  Future getStores({int? limit = 30, isRefresh = false}) async {
    if (isRefresh) {
      List<Store> list = [];
      for (var store in _storeList) {
        Store newStore = await storeProvider.storeById(store.storeId!);
        list.add(newStore);
      }
      _storeList = list;
      update();
    } else {
      for (var storeId in _user!.storeIds!) {
        await storeProvider.storeById(storeId).then((value) {
          _storeList.add(value);
          update();
        });
      }
      Map<String, bool> load = {..._loading.value};
      load['store'] = false;
      _loading.value = load;
    }
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

  Future updateStoreLimit(String storeId, int newLimit) async {
    _storeList.forEach((element) {
      if (element.storeId == storeId) {
        element.capacity = newLimit;
        update();
      }
    });
    await storeProvider.storeUpdate(storeId: storeId, capacity: newLimit);
    update();
  }

  Future resetStoreNumCustomers(String storeId) async {
    _storeList.forEach((element) {
      if (element.storeId == storeId) {
        element.customerCount = 0;
        element.highTempTimes = [];
        update();
      }
    });
    await storeProvider
        .storeUpdate(storeId: storeId, customerCount: 0, highTempTimes: []);
    update();
  }

  Future updateStoreLimitLocal(int newLimit) async {
    currCapacity = newLimit;
    update();
  }

  void onPanelSlide(double pos) {
    fabHeight = pos * (panelHeightOpen - panelHeightClosed) + initFabHeight;
    if (pos <= 0 && !firstTimePullUp) {
      updateStoreLimit(capacityChangeStoreId!, currCapacity!);
      capacityChangeActive = false;
      capacityChangeStoreId = null;
      currCapacity = 0;
    }
    firstTimePullUp = false;

    update();
  }

  void selectChangeCapacity(int index) {
    capacityChangeActive = true;
    capacityChangeStoreId = storeList[index].storeId!;
    currCapacity = storeList[index].capacity!;
    firstTimePullUp = true;
    panelController.animatePanelToPosition(1.0);

    update();
  }

  String daysSinceLastAccident() {
    int days = (DateTime.fromMillisecondsSinceEpoch(user!.lastTime!)
                .difference(
                    DateTime.fromMillisecondsSinceEpoch(user!.safeTime!))
                .inHours /
            24)
        .round();
    if (days > 0) {
      return "$days days without an accident";
    } else {
      return "DANGER!";
    }
  }
}
