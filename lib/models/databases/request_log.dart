class RequestLog {
  int id;
  String url;
  String params;
  String response;
  String time;
  int result;
  String resultStr;
  int uin;

  RequestLog();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'url': url,
      'params': params,
      'response': response,
      'time': time,
      'result': result,
      'resultStr': resultStr,
      'uin': uin,
    };
    return map;
  }

  RequestLog.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    url = map['url'];
    params = map['params'];
    response = map['response'];
    time = map['time'];
    result = map['result'];
    resultStr = map['resultStr'];
    uin = map['uin'];
  }
}
