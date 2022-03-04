import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:app/controllers/base_module/local_storage_data.dart';
import 'package:app/models/user.dart' as appuser;
import 'package:app/providers/user.dart';
import 'package:app/ui/auth_module/create_account_page.dart';
import 'package:app/ui/base_module/bottom_bar.dart';
import 'package:app/ui/home_module/home_page.dart';
import 'package:app/utils/app_images.dart';
import 'package:app/utils/progress_dialog.dart';

import 'package:firebase_messaging/firebase_messaging.dart'
as firebase_messaging;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  firebase_messaging.FirebaseMessaging _firebaseMessaging =
      firebase_messaging.FirebaseMessaging.instance;

  static AuthController get instance => Get.find<AuthController>();
  final UserProvider userProvider = UserProvider();
  final LocalStorageData localStorageData = LocalStorageData.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  appuser.User? get checkUser => _checkUser;
  appuser.User? _checkUser;

  String? get user => _user.value?.email;
  Rxn<User> _user = Rxn<User>();

  ValueNotifier<bool> get loading => _loading;
  ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  Future<void> onInit() async {
    super.onInit();
    _user.bindStream(auth.authStateChanges());
    print("done with firebase auth");
    await checkCurrentUser();
    print("done with user check");
    await setUpFCM();
    print("done with notification initialization");
  }

  _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString('user');
    return value == "" ? null: appuser.User.fromJson(json.decode(value!));
  }

  Future checkCurrentUser() async {
    appuser.User? localUser = await localStorageData.getUser();
    print(localUser == null ? "local is null " : localUser);
    if (localUser == null) {
      try {
        appuser.User? backendUser =
        await userProvider.userByEmailOrId(email: user);
        print(backendUser == null ? "backend is null " : backendUser);
        print(backendUser != null
            ? "user assigned to local"
            : "wtf is happening");
        _checkUser = backendUser!;
        update();
      } catch (e) {
        print("no user");
      }
    } else {
      print("user assigned to local");
      _checkUser = localUser;
      update();
    }
  }

  Future setUpFCM() async {
    print("setup fcm");
    getNotificationPermission();
    subscribeToTopic();
    onMessageListener();
    onTokenRefreshListener();
    checkTokenValid();
    print(await _firebaseMessaging.getToken());
  }

  void getNotificationPermission() async {
    firebase_messaging.NotificationSettings settings =
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    await firebase_messaging.FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    // const AndroidNotificationChannel channel = AndroidNotificationChannel(
    //   'com.sidharthgrover.foodbuddy', // id
    //   'High Importance Notifications', // title
    //   'This channel is used for important notifications.', // description
    //   importance: Importance.max,
    // );
    //
    // print(channel.description);
    //
    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    // FlutterLocalNotificationsPlugin();
    //
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel);
  }

  void subscribeToTopic() async {
    _firebaseMessaging.subscribeToTopic('global');
  }

  void onMessageListener() async {
    firebase_messaging.FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler);

    firebase_messaging.FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Get.to(HomePage());
    });

    firebase_messaging.FirebaseMessaging.onMessage
        .listen((firebase_messaging.RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        String messageTitle = message.notification!.title ?? "New Notification";
        String messageBody =
            message.notification!.body ?? "Click here to see all notifications";
        Get.snackbar(
          messageTitle,
          messageBody,
          icon: IconButton(
            icon: Image.asset(landing_page),
            onPressed: () => print("icon clicked"),
          ),
          colorText: Colors.white,
          onTap: (e) => Get.to(HomePage()),
        );
      }
    });
  }

  void onTokenRefreshListener() async {
    _firebaseMessaging.onTokenRefresh.listen((token) async {
      print("fcm token refreshed");
      if (auth.currentUser != null) {
        String? token = await _firebaseMessaging.getToken();
        appuser.User? user = await _getUserData();
        userProvider.userUpdate(
            userId: user!.userId!, notificationToken: token);
      }
    });
    _firebaseMessaging.onTokenRefresh.listen((onTokenRefresh) {});
  }

  void checkTokenValid() async {
    if (auth.currentUser != null) {
      String? token = await _firebaseMessaging.getToken();
      userProvider
          .userByEmailOrId(email: auth.currentUser!.email)
          .then((value) async {
        if (value == null) {
          print("token invalid, refreshing");
          appuser.User? user = await _getUserData();
          userProvider.userUpdate(
              userId: user!.userId!,        lastTime: DateTime.now().millisecondsSinceEpoch,
              notificationToken: token);
        } else if (value.notificationToken != token) {
          print("token invalid, refreshing");
          userProvider.userUpdate(
              userId: value.userId!,         lastTime: DateTime.now().millisecondsSinceEpoch,
              notificationToken: token);
        }
      });
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential? loginRes = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (loginRes == null) {
        // var registerRes = await FirebaseAuth.instance
        //     .createUserWithEmailAndPassword(email: email, password: password);
        //
        // var loginRes = await FirebaseAuth.instance
        //     .signInWithEmailAndPassword(email: email, password: password);
        var user = FirebaseAuth.instance.currentUser;
        await user!.getIdToken() ;
        return user;
      } else {
        var user = FirebaseAuth.instance.currentUser;
        return user;
      }
    } catch (e) {
      // var registerRes = await FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(email: email, password: password);
      //
      // var loginRes = await FirebaseAuth.instance
      //     .signInWithEmailAndPassword(email: email, password: password);
      var user = FirebaseAuth.instance.currentUser;
      return user;
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  Future<User?> googleSignInMethod() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    print(googleUser);
    GoogleSignInAuthentication googleSignInAuthentication =
    await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    await auth.signInWithCredential(credential).then((user) async {
      await signIn(user, method:'GoogleSignIn' );
    });
  }

  Future<void> signIn(UserCredential user, {method='GoogleSignIn'}) async {
    if (user.user == null) {
      Get.snackbar('Login Error', 'Unable to Create User',
          colorText: Colors.white);
    } else {
      bool res = await authenticateUser(user.user!.email);
      if (res) {
        ProgressDialog();
        print("old user");
        // await getCurrentUser(user.user!.email!);
        Get.offAll(() => BottomBar());
      } else {
        print("new user");
        await createUser("User", user.user!.email!);
        Get.offAll(() => CreateAccountPage());
      }
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect().whenComplete(() async {
      await _googleSignIn.signOut();
      return await auth.signOut();
    });
  }

  Future<bool> authenticateUser(String? email) async {
    final res = await userProvider.userByEmailOrId(email: email);
    if (res != null) {
      appuser.User user = res;
      await setUser(user);
      return true;
    }
    return false;
  }

  Future<void> createUser(String displayName, String email) async {
    try {
      String? notificationToken = await _firebaseMessaging.getToken();
      // List<String> interests = [
      //   "Not Applicable",
      //   "Not Applicable",
      //   "Not Applicable"
      // ];
      bool value = await userProvider.userCreate(
          name: displayName, email: email,notificationToken:  notificationToken!);
      if (value) {
        appuser.User? user =
        await userProvider.userByEmailOrId(email: email);
        setUser(user!);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<void> getCurrentUser(String email) async {
    try {
      appuser.User? user =
      await userProvider.userByEmailOrId(email: email);
      await setUser(user!);
    } catch (error) {
      print(error.toString());
    }
  }

  Future setUser(appuser.User user) async {
    try {
      await localStorageData.setUser(user);
    } catch (error) {
      print("SHARED" + error.toString());
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(
    firebase_messaging.RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.messageId}");
  print("Handling a background message: ${message.notification}");
}
