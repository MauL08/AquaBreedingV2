import 'dart:convert';

import 'package:fish/models/pond_model.dart';
import 'package:fish/pages/fish/fish_type_controller.dart';
import 'package:fish/service/fish_death_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/activation_model.dart';
import '../../service/logging_service.dart';

class FishDeathEntryController extends GetxController {
  TextEditingController formDeathController = TextEditingController(text: '');
  FishTypeController fishTypeController = FishTypeController();
  Activation activation = Get.arguments["activation"];
  Pond pond = Get.arguments["pond"];
  final fishamount = ''.obs;
  final validatefishamount = false.obs;
  var isLoading = false.obs;
  RxList<String> listFishAlive = List<String>.empty().obs;
  Future<void> getFish() async {
    isLoading.value = true;
    listFishAlive.add("pilih ikan");
    for (var i in activation.fishLive!) {
      listFishAlive.add(i.type!);
      print(listFishAlive);
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    getFish();
  }

  void fishamountChanged(String val) {
    fishamount.value = val;
  }

  void valfishamount() {
    validatefishamount.value = true;
  }

  List buildJson() {
    var list = [];
    var data = {
      "type": fishTypeController.selected.value,
      "amount": formDeathController.value.text,
    };
    list.add(jsonEncode(data));
    return list;
  }

  Future<void> postFishDeath() async {
    bool value = await FishDeathService().postFishDeath(
      pondId: pond.id,
      fish: buildJson(),
    );
    print(value);
  }

  final DateTime startTime = DateTime.now();
  late DateTime endTime;
  final fitur = 'Fish Death';

  Future<void> postDataLog(String fitur) async {
    // print(buildJsonFish());
    bool value =
        await LoggingService().postLogging(startAt: startTime, fitur: fitur);
    print(value);
  }

  @override
  void dispose() {
    formDeathController.clear();
    postDataLog(fitur);
    super.dispose();
  }
}
