import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rose_fz/global.dart';
import 'package:rose_fz/user.dart';
import 'package:rose_fz/utils/mg.dart';
import 'package:rose_fz/utils/mg_data.dart';

final dateFormat = new DateFormat('yyyy-MM-dd HH:mm:ss');

class Warehouse extends StatefulWidget {
  @override
  _ActivityState createState() {
    return new _ActivityState();
  }
}

class Item {
  Item({
    this.data,
    this.headerValue,
    this.isExpanded = false,
  });

  String headerValue;
  bool isExpanded;
  Map<int, int> data;
}

class _ActivityState extends State<Warehouse> {
  List<Item> _data = List();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Global.init();
    User.initFirstRes = await MGUtil.getInitFirst();
    _data.add(Item(
      headerValue: '鲜花',
      data: User.initFirstRes.vegetablefruit,
    ));
    _data.add(Item(
      headerValue: '玫瑰',
      data: User.initFirstRes.rose,
    ));
    _data.add(Item(
      headerValue: '玫瑰原料',
      data: User.initFirstRes.roseseed,
    ));
    _data.add(Item(
      headerValue: '特殊道具',
      data: User.initFirstRes.prop,
    ));
    setState(() {
      _data = _data;
    });
  }

  Widget _buildXianHua(Map<int, int> data) {
    var keys = data.keys.toList();
    keys.sort((a, b) => (b).compareTo(a));
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: keys.length,
      itemBuilder: (context, i) {
        var info = MGDataUtil.dicMapId[keys[i].toString()];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(info?.name ?? '' + ' ' + keys[i].toString()),
              ),
              Text(data[keys[i]].toString())
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(height: 1.0, color: Colors.grey[300]);
      },
    );
  }

  Widget _buildMeiGui(Map<int, int> data) {
    var keys = data.keys.toList();
    // keys.sort((a, b) => (b).compareTo(a));
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: keys.length,
      itemBuilder: (context, i) {
        var name = Global.getFlowerInfoById(keys[i])?.name ??
            '' + ' ' + keys[i].toString();
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(name),
              ),
              Text('${data[keys[i]] ~/ 30}束${data[keys[i]] % 30}朵')
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(height: 1.0, color: Colors.grey[300]);
      },
    );
  }

  Widget _buildMeiGuiYuanLiao(Map<int, int> data) {
    var keys = data.keys.toList();
    // keys.sort((a, b) => (b).compareTo(a));
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: keys.length,
      itemBuilder: (context, i) {
        var name = Global.getFlowerInfoById(keys[i])?.name ??
            '' + ' ' + keys[i].toString();
        var a = Global.config['meterial']
            .findAllElements("item")
            .where((xe) =>
                xe.getAttribute('seedID') == '${keys[i]}' ||
                xe.getAttribute('id') == '${keys[i]}')
            .toList();
        if (a.length > 0) {
          name = a[0].getAttribute("name");
        }
        // var name = info?.name ?? '' + ' ' + keys[i].toString();
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(name),
              ),
              Text('${data[keys[i]]}')
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(height: 1.0, color: Colors.grey[300]);
      },
    );
  }

  Widget _buildTeShuDaoJu(Map<int, int> data) {
    var keys = data.keys.toList();
    keys.sort((a, b) => (b).compareTo(a));
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: keys.length,
      itemBuilder: (context, i) {
        var info = MGDataUtil.dicMapId[keys[i].toString()];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(info?.name ?? '' + ' ' + keys[i].toString()),
              ),
              Text(data[keys[i]].toString())
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(height: 1.0, color: Colors.grey[300]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var vegetablefruit = User.initFirstRes.vegetablefruit;
    var vegetablefruitKeys = vegetablefruit.keys.toList();
    vegetablefruitKeys.sort((a, b) => (b).compareTo(a));
    return SingleChildScrollView(
      child: Container(
        child: ExpansionPanelList.radio(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _data[index].isExpanded = !isExpanded;
            });
          },
          children: _data.map<ExpansionPanel>((Item item) {
            Widget child;
            if (item.headerValue == "鲜花") {
              child = _buildXianHua(item.data);
            } else if (item.headerValue == "玫瑰") {
              child = _buildMeiGui(item.data);
            } else if (item.headerValue == "玫瑰原料") {
              child = _buildMeiGuiYuanLiao(item.data);
            } else {
              child = _buildTeShuDaoJu(item.data);
            }
            return ExpansionPanelRadio(
              canTapOnHeader: true,
              value: item.headerValue,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text('${item.headerValue}(${item.data.length})'),
                );
              },
              body: child,
            );
          }).toList(),
        ),
      ),
    );
  }
}
