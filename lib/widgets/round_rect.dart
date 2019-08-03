import 'package:flutter/material.dart';

class RoundRect extends Container {
  RoundRect({
    Key key,
    String text,
    Color color,
    EdgeInsets margin,
    bool visible,
  }) : super(
          key: key,
          margin: visible != null && !visible
              ? null
              : margin ?? EdgeInsets.only(right: 10),
          alignment: Alignment(0, 0),
          height: visible != null && !visible ? 0 : 18,
          width: visible != null && !visible ? 0 : 36,
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
