import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSnackBarWithViewBag(GlobalKey<ScaffoldState> _key ,BuildContext context, String s) {

  _key.currentState!.showSnackBar(SnackBar(
    content: Text('$s'),
    action: SnackBarAction(
      label: 'View Bag',
      onPressed: () => Navigator.of(context).pushNamed('/cartDetail'),) ,
  ));
}


void showOnlySnackBar(GlobalKey<ScaffoldState> _key ,BuildContext context, String s) {

  _key.currentState!.showSnackBar(SnackBar(content: Text('$s')));
}