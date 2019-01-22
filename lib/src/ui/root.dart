import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:offers/src/bloc/bloc.dart';
import 'package:offers/src/ui/city.dart';
import 'package:offers/src/ui/loader.dart';
import 'package:offers/src/ui/main.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Bloc bloc = BlocProvider.of<Bloc>(context);
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        Widget widget;
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            if (!snapshot.hasData) {
              widget = City();
            } else {
              widget = snapshot.data != "" ? Main() : City();
            }
            break;
          default:
            widget = LoaderWithScaffold();
            break;
        }
        return widget;
      },
      stream: bloc.cityStream,
    );
  }
}
