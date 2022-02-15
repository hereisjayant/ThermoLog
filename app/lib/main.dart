import 'package:app/controllers/base_module/local_storage_data.dart';
import 'package:app/ui/base_module/bottom_bar.dart';
import 'package:app/utils/app_colors.dart';
import 'package:app/utils/binding.dart';
import 'package:app/utils/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: Binding(),
      title: 'ThermoLog',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: darkHighlight),
      ),
      home: GetBuilder<LocalStorageData>(
        init: LocalStorageData(),
        builder: (controller) => controller.loading.value
            ? Scaffold(
            backgroundColor: darkPrimary, body: Center(child: ProgressDialog()))
            : Scaffold(
          body: BottomBar(),
        ),
      ),
    );
  }
}