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
  final PickerCallback onSelect;

  Picker({this.label, this.items, this.onSelect});

  @override
  _PickerState createState() {
    return new _PickerState(
        label: this.label, items: this.items, onSelect: this.onSelect);
  }
}

class _PickerState extends State<Picker> {
  final List<PickerItem> items;
  final String label;
  final PickerCallback onSelect;
  dynamic selectValue;

  _PickerState({this.label, this.items, this.onSelect});

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
          selectValue = item.value;
        } else {
          selectValue = null;
        }
      });
      onSelect(item);
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
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              items
                      .firstWhere((item) => item.value == selectValue,
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
