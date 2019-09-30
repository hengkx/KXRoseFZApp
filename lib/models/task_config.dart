class TaskConfig {
  int id;
  String name;
  String ruleDesc;
  String ruleTip;
  List<TaskCond> conds;
  TaskConfig({this.id, this.name, this.ruleDesc, this.ruleTip, this.conds});
}

class TaskCond {
  String id;
  String name;
  int count;
  String type;

  TaskCond({this.id, this.name, this.count, this.type});
}
