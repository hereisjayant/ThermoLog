import 'dart:math';

import 'package:app/controllers/home_module/home_page.dart';
import 'package:app/utils/base_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

class CapacityChangeView extends StatelessWidget with BaseClass {
  final String? storeId;

  CapacityChangeView({required this.storeId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
      init: HomePageController(),
      builder: (controller) =>
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        NumberPicker(
          value: controller.currCapacity!,
          minValue: 0,
          maxValue: 500,
          step: 1,
          itemHeight: 100,
          axis: Axis.horizontal,
          onChanged: (value) => controller.updateStoreLimitLocal(value),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black26),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => controller
                  .updateStoreLimitLocal(max(0, controller.currCapacity! - 1)),
            ),
            Text('Current capacity: ${controller.currCapacity!}'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => controller.updateStoreLimitLocal(
                  min(500, controller.currCapacity! + 1)),
            ),
          ],
        ),
      ]),
    );
  }
}
