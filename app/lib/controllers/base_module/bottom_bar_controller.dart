import 'package:app/ui/home_module/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBarController extends GetxController {
  int? selectedValue;
  bool clickedCentreFAB = false; //boolean used to handle container animation which expands from the FAB


  //call this method on click of each bottom app bar item to update the screen

  BottomBarController({this.selectedValue = 0});

  int get navigatorValue => _navigatorValue!;
  int? _navigatorValue;

  bool get isFABVisible => _isFABVisible;
  bool _isFABVisible = true;

  Widget? currentScreen;

  @override
  void onInit() {
    changeSelectedValue(selectedValue!);
    super.onInit();
  }

  void changeSelectedValue(int _selectedValue) {
    _navigatorValue = _selectedValue;
    switch (_selectedValue) {
      case 0:
        {
          currentScreen = HomePage();
          break;
        }
    }

    update();
  }

  void displayFAB(shouldShow){
    _isFABVisible = shouldShow;
    update();
  }

  void toggleButton(){
    clickedCentreFAB = !clickedCentreFAB;
    update();
  }

}
