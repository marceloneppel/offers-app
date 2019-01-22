import 'package:flutter/material.dart';

class OffersAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget navigationItem;
  final Widget title;

  const OffersAppBar({Key key, this.navigationItem, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: true,
      actions: <Widget>[
        navigationItem != null ? navigationItem : Container(),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}
