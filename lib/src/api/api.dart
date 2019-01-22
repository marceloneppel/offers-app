import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:offers/src/app/const.dart';
import 'package:offers/src/data/offer.dart';
import 'package:offers/src/data/result.dart';

void add() {}

void delete() {}

void get() {}

Future<Result> list() async {
  List<Offer> data;
  String error;
  debugPrint("api list called");
  Response response = await Client().get('$apiEndpoint');
  if (response.statusCode != 200) {
    error = response.statusCode.toString();
  } else {
    Result parseResult = await compute(parseOffers, response.body);
    data = parseResult.unwrap();
    error = parseResult.unwrapError();
  }
  return Result(data, error);
}

Result parseOffers(String responseBody) {
  List<Offer> data;
  String error;
  debugPrint("api parseOffers called");
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  data = parsed.map<Offer>((json) => Offer.fromJson(json)).toList();
  return Result(data, error);
}

void update() {}
