import 'dart:convert';
import 'dart:developer';

import 'package:fish/core/baseUrl.dart';
import 'package:fish/models/inventaris/suplemen/detail_inventaris_suplemen_model.dart';
import 'package:fish/models/inventaris/suplemen/inventaris_suplemen_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InventarisBahanBudidayaState extends BaseURL {
  RxBool isLoadingPage = false.obs;
  RxBool isLoadingPost = false.obs;
  RxBool isLoadingDelete = false.obs;
  RxBool isLoadingDetail = false.obs;

  var suplemenList = InventarisSuplemenModel(data: []).obs;

  RxList filterList = [
    {'title_id': 1, 'title': 'Obat', 'key': 'obat'},
    {'title_id': 2, 'title': 'Perawatan Air', 'key': 'perawatan'},
    {'title_id': 3, 'title': 'Probiotik', 'key': 'probiotik'},
    {'title_id': 4, 'title': 'Feed Additive', 'key': 'feed'},
  ].obs;

  RxString pageIdentifier = 'Obat'.obs;
  RxInt currIndexFilter = 1.obs;

  var dropdownList = [
    'Obat',
    'Perawatan Air',
    'Probiotik',
    'Feed Additive',
  ];

  var dropdownList2 = [
    'kg',
    'ltr',
    'pack',
  ];

  RxString functionCategory = 'Perawatan Air'.obs;
  RxString typeCategory = 'kg'.obs;
  TextEditingController name = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController minExp = TextEditingController();
  TextEditingController maxExp = TextEditingController();
  RxString image =
      'https://d1vbn70lmn1nqe.cloudfront.net/prod/wp-content/uploads/2021/06/28062837/vector_5.kesehatan-vitamin-dan-suplemen.jpg'
          .obs;

  Future getAllData(String type, Function() doAfter) async {
    suplemenList.value.data!.clear();
    isLoadingPage.value = true;
    final response =
        await http.get(Uri.parse('$baseUrl/inventory/suplemen?type=$type'));

    try {
      if (response.statusCode == 200) {
        InventarisSuplemenModel res =
            InventarisSuplemenModel.fromJson(jsonDecode(response.body));

        suplemenList.value = res;
        inspect(suplemenList.value.data);

        doAfter();
      }
    } catch (e) {
      throw Exception(e);
    }
    isLoadingPage.value = false;
  }

  Future getDataByID(int id, Function() doAfter) async {
    isLoadingDetail.value = true;

    final response =
        await http.get(Uri.parse('$baseUrl/inventory/suplemen/$id'));

    try {
      if (response.statusCode == 200) {
        DetailInventarisSuplemenModel res =
            DetailInventarisSuplemenModel.fromJson(jsonDecode(response.body));

        functionCategory.value = res.data!.function!.toString();
        name.text = res.data!.name.toString();
        desc.text = res.data!.description.toString();
        price.text = res.data!.price.toString();
        amount.text = res.data!.amount.toString();
        typeCategory.value = res.data!.type.toString();
        minExp.text = res.data!.minExpiredPeriod.toString();
        maxExp.text = res.data!.maxExpiredPeriod.toString();
        image.value = res.data!.image.toString();
      }
      doAfter();
    } catch (e) {
      throw Exception(e);
    }
    isLoadingDetail.value = false;
  }

  Future postData(Function() doAfter) async {
    var map = <String, dynamic>{};

    map['function'] = functionCategory.value;
    map['name'] = name.text;
    map['description'] = desc.text;
    map['price'] = price.text;
    map['amount'] = amount.text;
    map['type'] = typeCategory.value;
    map['min_expired_period'] = minExp.text;
    map['max_expired_period'] = maxExp.text == ''
        ? (int.parse(minExp.text) * 2).toString()
        : maxExp.text;
    map['image'] = image.value;

    isLoadingPost.value = true;

    try {
      await http.post(
        Uri.parse('$baseUrl/inventory/suplemen'),
        body: map,
      );
      doAfter();
    } catch (e) {
      throw Exception(e);
    }
    isLoadingPost.value = false;
  }

  Future updateData(int id, Function() doAfter) async {
    var map = <String, dynamic>{};

    inspect(id);

    map['function'] = functionCategory.value;
    map['name'] = name.text;
    map['description'] = desc.text;
    map['price'] = price.text;
    map['amount'] = amount.text;
    map['type'] = typeCategory.value;
    map['min_expired_period'] = minExp.text;
    map['max_expired_period'] = maxExp.text == ''
        ? (int.parse(minExp.text) * 2).toString()
        : maxExp.text;
    map['image'] = image.value;

    isLoadingPost.value = true;

    try {
      inspect(map);
      final res = await http.put(
        Uri.parse('$baseUrl/inventory/suplemen/$id'),
        body: map,
      );
      inspect(res);
      doAfter();
    } catch (e) {
      throw Exception(e);
    }
    isLoadingPost.value = false;
  }

  Future deleteData(int id, Function() doAfter) async {
    isLoadingDelete.value = true;
    try {
      await http.delete(
        Uri.parse(
          '$baseUrl/inventory/suplemen/$id',
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      doAfter();
    } catch (e) {
      throw Exception(e);
    }
    isLoadingDelete.value = false;
  }

  resetVariables() {
    name.clear();
    desc.clear();
    price.clear();
    amount.clear();
    minExp.clear();
    maxExp.clear();
  }

  convertDaysToDate(DateTime time, int days) {
    DateTime newTime = time.add(Duration(days: days));
    return newTime.toString().split(' ')[0].split('-').reversed.join('-');
  }
}
