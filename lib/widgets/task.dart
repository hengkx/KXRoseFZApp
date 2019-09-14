import '../response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../utils/mg.dart';
import '../global.dart';

final dateFormat = new DateFormat('MM-dd HH:mm');

class Task extends StatefulWidget {
  @override
  _TaskState createState() {
    return new _TaskState();
  }
}

class TaskConfig {
  String name;
  String ruleDesc;
  String ruleTip;
  int ruleLen;
}

class _TaskState extends State<Task> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Global.init();
    await loadTask();
  }

  List<UserTask> tasks = [];
  final SlidableController slidableController = SlidableController();

  Future<void> loadTask() async {
    var data = await MGUtil.getTasks();

    this.setState(() {
      tasks = data.userTasks.where((p) => p.state != 1).toList();
      tasks.sort((prev, next) =>
          (next.data1 + next.data2 + next.data3 + next.data4 + next.data5) -
          (prev.data1 + prev.data2 + prev.data3 + prev.data4 + prev.data5));
    });
  }

  showSnackBar(String tip) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(tip),
      duration: Duration(seconds: 1),
    ));
  }

  TaskConfig getTaskConfig(task) {
    TaskConfig taskConfig = new TaskConfig();
    for (var item in Global.config['task'].findAllElements("item")) {
      if (item.getAttribute('id') == "${task.taskID}") {
        taskConfig.name = item.getAttribute('name');
        var rule = item.findAllElements("rule").toList()[0];
        taskConfig.ruleDesc = rule.getAttribute("comment");
        var tips = rule.findAllElements("tip").toList();
        if (tips.length > 0) {
          taskConfig.ruleTip =
              tips[0].text.replaceAll("\$propdata1\$", "${task.data1}").trim();
        }
        taskConfig.ruleLen = rule.findAllElements("prop").length;
      }
    }
    return taskConfig;
  }

  String getTaskTip(UserTask task, TaskConfig taskConfig) {
    switch (taskConfig.ruleLen) {
      case 1:
        return "${task.data1}";
      case 2:
        return "${task.data1} ${task.data2}";
      case 3:
        return "${task.data1} ${task.data2} ${task.data3}";
      case 4:
        return "${task.data1} ${task.data2} ${task.data3} ${task.data4}";
      case 5:
        return "${task.data1} ${task.data2} ${task.data3} ${task.data4} ${task.data5}";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: RefreshIndicator(
            onRefresh: loadTask,
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                var task = tasks[index];
                var taskConfig = getTaskConfig(task);
                final List<Widget> slideActions = [];
                final List<Widget> slideSecondaryActions = [];
                return Slidable(
                  key: ValueKey(task.taskID),
                  controller: slidableController,
                  actionPane: SlidableDrawerActionPane(),
                  actions: slideActions,
                  secondaryActions: slideSecondaryActions,
                  // enabled: soil.type != 2,
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
                                        taskConfig.name,
                                        style: TextStyle(
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
                                  taskConfig.ruleDesc,
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
                                  taskConfig.ruleTip ??
                                      getTaskTip(task, taskConfig),
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
              itemCount: tasks.length,
            ),
          ),
        )
      ],
    );
  }
}
