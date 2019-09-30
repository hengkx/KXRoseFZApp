import 'package:rose_fz/models/task_config.dart';
import 'package:rose_fz/user.dart';
import 'package:rose_fz/utils/mg_data.dart';

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

  List<UserTask> _tasks = [];
  final SlidableController _slidableController = SlidableController();

  Future<void> loadTask() async {
    var data = await MGUtil.getTasks();

    this.setState(() {
      // state 好像是完成
      // _tasks = data.userTasks.where((p) => p.state != 1).toList();
      _tasks = data.userTasks;
      _tasks.sort((prev, next) =>
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

  int getMaterialCount(TaskCond cond) {
    int count;
    if (cond.type == 'flower') {
      count = User.initFirstRes.warehouse[int.parse(cond.id)];
    } else if (cond.type == 'rose') {
      count = User.initFirstRes.warehouse[MGDataUtil.dicMapId[cond.id].localId];
    } else {
      print(cond.type);
      return -1;
    }
    return count ?? 0;
  }

  String getCondName(TaskCond cond) {
    if (cond.name == null) {
      return '次数';
    }
    int count = getMaterialCount(cond);
    if (count != -1) {
      return '${cond.name}($count)';
    }
    return cond.name;
  }

  Widget buildCondProgress(int count, TaskCond cond) {
    return Row(
      children: <Widget>[
        Container(
          width: 70,
          child: Text(
            getCondName(cond),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
        Container(
          width: 50,
          child: Text('$count',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: count >= cond.count ? Colors.red : Colors.grey,
                fontSize: 12,
              )),
        ),
        Text(' / '),
        Container(
          width: 60,
          child: Text(
            '${cond.count}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ),
        // Text('种子数量：${getMaterialCount(cond)}'),
      ],
    );
  }

  Widget buildTaskProgress(UserTask task, TaskConfig cfg) {
    final List<Widget> widgets = [];
    var len = cfg.conds.length;
    if (len >= 1) {
      widgets.add(buildCondProgress(task.data1, cfg.conds[0]));
    }
    if (len >= 2) {
      widgets.add(buildCondProgress(task.data2, cfg.conds[1]));
    }
    if (len >= 3) {
      widgets.add(buildCondProgress(task.data3, cfg.conds[2]));
    }
    if (len >= 4) {
      widgets.add(buildCondProgress(task.data4, cfg.conds[3]));
    }
    if (len >= 5) {
      widgets.add(buildCondProgress(task.data5, cfg.conds[4]));
    }

    return Column(children: widgets);
  }

  Widget buildName(TaskConfig cfg) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text(
                  cfg.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRule(TaskConfig cfg) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(children: <Widget>[
        Expanded(
          child: Text(
            cfg.ruleDesc,
            style: new TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ),
      ]),
    );
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
                var task = _tasks[index];
                var cfg = Global.getTaskInfoById(task.taskID);
                final List<Widget> slideActions = [];
                final List<Widget> slideSecondaryActions = [];
                return Slidable(
                  key: ValueKey(task.taskID),
                  controller: _slidableController,
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
                          buildName(cfg),
                          buildRule(cfg),
                          buildTaskProgress(task, cfg),
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
              itemCount: _tasks.length,
            ),
          ),
        )
      ],
    );
  }
}
