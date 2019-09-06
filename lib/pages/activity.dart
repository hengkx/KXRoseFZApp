import 'package:KXRoseFZApp/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../widgets/round_rect.dart';
import '../utils/mg.dart';
import '../config.dart';

final dateFormat = new DateFormat('yyyy-MM-dd HH:mm');

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() {
    return new _ActivityState();
  }
}

class ActConfig {
  String id;
  String name;
  int start;
  int end;
  String desc;
  bool isActive;
  int sort;
}

class _ActivityState extends State<Activity> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Config.init();
    DateTime now = DateTime.now();
    var unixtime = now.millisecondsSinceEpoch / 1000;
    var limit = Config.actGuideConfig.findAllElements('limit').toList()[0];
    for (var item in limit.findAllElements('item')) {
      if (item.getAttribute('start') != null) {
        ActConfig actConfig = ActConfig();
        actConfig.id = item.getAttribute('id');
        actConfig.name = item.getAttribute('name');
        actConfig.start = int.parse(item.getAttribute('start'));
        actConfig.end = int.parse(item.getAttribute('end'));
        actConfig.desc = item.getAttribute('desc');
        actConfig.isActive =
            unixtime > actConfig.start && unixtime < actConfig.end;
        actConfig.sort = actConfig.isActive ? int.parse(actConfig.id) : 0;
        actConfigs.add(actConfig);
      }
    }
    actConfigs.sort((a, b) => b.sort - a.sort);
    setState(() {
      actConfigs = actConfigs;
    });
  }

  List<ActConfig> actConfigs = [];
  final SlidableController slidableController = SlidableController();

  showSnackBar(String tip) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(tip),
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        var actConfig = actConfigs[index];
        final List<Widget> slideActions = [];
        final List<Widget> slideSecondaryActions = [];
        return Slidable(
          key: ValueKey(actConfig.id),
          controller: slidableController,
          actionPane: SlidableDrawerActionPane(),
          actions: slideActions,
          secondaryActions: slideSecondaryActions,
          enabled: false,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Text(
                                actConfig.name,
                                style: TextStyle(
                                  color: actConfig.isActive
                                      ? Colors.black
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: Text(
                          actConfig.desc,
                          style: new TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${dateFormat.format(new DateTime.fromMillisecondsSinceEpoch(actConfig.start * 1000))} - ${dateFormat.format(new DateTime.fromMillisecondsSinceEpoch(actConfig.end * 1000))}',
                          style: new TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {},
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return new Container(height: 1.0, color: Colors.grey[300]);
      },
      itemCount: actConfigs.length,
    );
  }
}
