class RequestLog {
  int id;
  String url;
  String params;
  String response;
  String time;

  RequestLog();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'url': url,
      'params': params,
      'response': response,
      'time': time,
    };
    return map;
  }

  RequestLog.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    url = map['url'];
    params = map['params'];
    response = map['response'];
    time = map['time'];
  }
}
