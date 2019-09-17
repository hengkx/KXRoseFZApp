import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

final dateFormat = new DateFormat('MM-dd HH:mm');

class PickerItem {
  String text;
  dynamic value;
  PickerItem({this.text, this.value});
}

typedef PickerCallback = void Function(PickerItem item);

class Picker extends StatefulWidget {
  final String label;
  final List<PickerItem> items;
  final ValueChanged<PickerItem> onChange;
  final dynamic value;

  Picker({
    Key key,
    this.label,
    this.items,
    @required this.value,
    @required this.onChange,
  }) : super(key: key);

  @override
  _PickerState createState() {
    return new _PickerState(
      label: this.label,
      items: this.items,
      value: this.value,
      onChange: this.onChange,
    );
  }
}

class _PickerState extends State<Picker> {
  final List<PickerItem> items;
  final String label;
  final ValueChanged<PickerItem> onChange;
  dynamic value;

  _PickerState({this.label, this.items, this.value, this.onChange});

  @override
  void initState() {
    super.initState();
  }

  showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.separated(
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            var item = items[index];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        item.text,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context, item);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Container(height: 1.0, color: Colors.grey[300]);
          },
          itemCount: items.length,
        );
      },
    ).then((item) {
      setState(() {
        if (item != null) {
          value = item.value;
        } else {
          value = null;
        }
      });
      onChange(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Text(label),
                ],
              ),
            ),
            Text(
              items
                      .firstWhere((item) => item.value == value,
                          orElse: () => null)
                      ?.text ??
                  '',
            ),
            Icon(Icons.keyboard_arrow_right),
          ],
        ),
      ),
      onTap: showPicker,
    );
  }
}
