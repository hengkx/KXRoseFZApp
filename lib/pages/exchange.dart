import '../widgets/text_field_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils/mg.dart';
import '../global.dart';

class ExchangePage extends StatefulWidget {
  @override
  _ExchangePageState createState() {
    return new _ExchangePageState();
  }
}

class _ExchangePageState extends State<ExchangePage> {
  showNumDialog(BuildContext context, ExchangeItem item) {
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
        exchange(context, item, int.parse(text));
      }
    });
  }

  showSnackBar(BuildContext context, String tip) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(tip),
      duration: Duration(seconds: 1),
    ));
  }

  exchange(BuildContext context, ExchangeItem item, int count) async {
    for (var i = 0; i < count; i++) {
      var res = await MGUtil.exchange(item.id);
      if (res.result == 0) {
        showSnackBar(context, "兑换一个 ${item.name} 成功");
      } else {
        showSnackBar(context, "兑换 ${res.resultstr}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("万能种子兑换"),
      ),
      body: Container(
        alignment: Alignment(0, 0),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            var exchange = Global.exhanges[index];
            return ListTile(
              title: Text(exchange.name),
              onTap: () {
                showNumDialog(context, exchange);
              },
            );
          },
          itemCount: Global.exhanges.length,
        ),
      ),
    );
  }
}
