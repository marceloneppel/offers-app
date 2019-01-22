import 'package:flutter/material.dart';
import 'package:offers/src/app/const.dart';

class Loader extends StatelessWidget {
  final Widget top;

  const Loader({Key key, this.top}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          top != null
              ? Column(
                  children: <Widget>[
                    top,
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                )
              : Container(),
          CircularProgressIndicator(),
          SizedBox(
            height: 10.0,
          ),
          Text(
            loadingText,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

class LoaderWithScaffold extends StatelessWidget {
  final Widget top;

  const LoaderWithScaffold({Key key, this.top}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Loader(
          top: top,
        ),
      ),
    );
  }
}
