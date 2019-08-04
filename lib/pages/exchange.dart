import 'dart:math';
import 'package:KXRoseFZApp/user_config.dart';
import 'package:KXRoseFZApp/widgets/text_field_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';

import '../utils/mg.dart';
import '../config.dart';

class ExchangeWidget extends StatefulWidget {
  @override
  _ExchangeWidgetState createState() {
    return new _ExchangeWidgetState();
  }
}

class _ExchangeWidgetState extends State<ExchangeWidget> {
  showNumDialog(ExchangeItem item) {
    showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return TextFieldAlertDialog(
          context: context,
          title: "兑换数量",
          value: "1",
        );
      },
    ).then((String text) {
      if (text != null) {
        exchange(item, int.parse(text));
      }
    });
  }

  showSnackBar(String tip) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(tip),
      duration: Duration(seconds: 1),
    ));
  }

  exchange(ExchangeItem item, int count) async {
    for (var i = 0; i < count; i++) {
      var res = await MGUtil.exchange(item.id);
      if (res.result == 0) {
        showSnackBar("兑换一个 ${item.name} 成功");
      } else {
        showSnackBar("兑换 ${res.resultstr}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, 0),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var exchange = Config.exhanges[index];
          return ListTile(
            title: Text(exchange.name),
            onTap: () {
              showNumDialog(exchange);
            },
          );
        },
        itemCount: Config.exhanges.length,
      ),
    );
  }
}
