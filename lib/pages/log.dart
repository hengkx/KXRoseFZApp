import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rose_fz/models/databases/request_log.dart';
import 'package:rose_fz/utils/db.dart';
import 'package:rose_fz/global.dart';
import 'package:rose_fz/models/flower.dart';
import 'package:rose_fz/pages/select_flower.dart';

class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() {
    return new _LogPageState();
  }
}

class _LogPageState extends State<LogPage> {
  ScrollController scrollController = ScrollController();
  List<RequestLog> logs = [];
  int offset = 0;
  bool finished = false;

  @override
  void initState() {
    super.initState();
    loadData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!finished) {
          loadMore();
        }
      }
    });
  }

  Future loadMore() async {
    var db = DBUtil();
    var requestLogs = await db.getAllRequestLogs(limit: 20, offset: offset);
    setState(() {
      logs.addAll(requestLogs);
      offset += 20;
      finished = requestLogs.length < 20;
    });
  }

  Future loadData() async {
    offset = 0;
    finished = false;
    var db = DBUtil();
    var requestLogs = await db.getAllRequestLogs(limit: 20, offset: offset);
    setState(() {
      logs = requestLogs;
      offset += 20;
      finished = requestLogs.length < 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("日志"),
      ),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            var log = logs[index];
            return Column(
              children: <Widget>[
                Text(log.url),
                Text(log.params),
                Text(log.result.toString()),
                // Text(log.response),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return new Container(height: 1.0, color: Colors.grey[300]);
          },
          itemCount: logs.length,
          controller: scrollController,
        ),
      ),
    );
  }
}
