import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldAlertDialog extends AlertDialog {
  static final controller = TextEditingController();
  TextFieldAlertDialog({
    Key key,
    BuildContext context,
    String title,
    String hitText,
    String okText,
    String value,
  }) : super(
          key: key,
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  controller: controller,
                  decoration: new InputDecoration(labelText: hitText),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[0-9]")),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            OutlineButton(
              child: Text(
                '取消',
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                okText ?? '确定',
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ],
        ) {
    controller.text = value ?? "";
    controller.selection =
        TextSelection(baseOffset: 0, extentOffset: controller.text.length);
  }
}
