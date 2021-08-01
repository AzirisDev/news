import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildLoaderWidget() {
  return Center(
    child: Column(
      children: [
        const CupertinoActivityIndicator(),
      ],
    ),
  );
}
