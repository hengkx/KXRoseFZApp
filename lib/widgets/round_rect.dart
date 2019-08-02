import 'package:flutter/material.dart';

class RoundRect extends Container {
  RoundRect({
    Key key,
    String text,
    Color color,
  }) : super(
          key: key,
          margin: EdgeInsets.only(right: 10),
          alignment: Alignment(0, 0),
          height: 18,
          width: 36,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
            border: new Border.all(width: 1, color: color),
          ),
          child: Text(
            text,
            style: new TextStyle(
              color: color,
              fontSize: 10,
            ),
          ),
        );
}
