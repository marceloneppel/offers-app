import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:offers/src/api/api.dart';
import 'package:offers/src/data/offer.dart';
import 'package:offers/src/data/result.dart';
import 'package:offers/src/data/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class Bloc implements BlocBase {

  Bloc();

  // City
  BehaviorSubject<String> _cityController =
      BehaviorSubject<String>(seedValue: "");

  Sink<String> get _citySink => _cityController.sink;

  Stream<String> get cityStream => _cityController.stream;

  void loadCity() async {
    debugPrint("bloc loadCity called");
    String city = await getCity();
    if (city != "") {
      _citySink.add(city);
      await loadOffers();
    }
  }

  Future<void> updateCity(String city) async {
    debugPrint("bloc updateCity called");
    await setCity(city);
    _citySink.add(city);
    await loadOffers();
  }

  // Offers
  BehaviorSubject<List<Offer>> _offersController =
      BehaviorSubject<List<Offer>>(seedValue: []);

  Sink<List<Offer>> get _offersSink => _offersController.sink;

  Stream<List<Offer>> get offersStream => _offersController.stream;

  Future<void> loadOffers() async {
    debugPrint("bloc loadOffers called");
    Result result = await list();
    if (result.isError()) {
      debugPrint(
          "bloc loadOffers result.unwrapError(): ${result.unwrapError()}");
      _offersController.addError(result.unwrapError());
    } else {
      debugPrint("bloc loadOffers result.unwrap(): ${result.unwrap()}");
      _offersSink.add(result.unwrap());
    }
  }

  @override
  void dispose() {
    _cityController.close();
    _offersController.close();
  }
}
