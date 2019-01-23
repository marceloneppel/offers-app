import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:offers/src/app/const.dart';
import 'package:offers/src/bloc/bloc.dart';
import 'package:offers/src/ui/splash.dart';

class OffersApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OffersAppState();
  }
}

class _OffersAppState extends State<OffersApp> {
  final Bloc bloc = Bloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: MaterialApp(
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: Splash(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    bloc.loadCity();
  }
}
