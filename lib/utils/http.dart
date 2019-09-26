import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rose_fz/user.dart';
import 'package:rose_fz/utils/uin_crypt.dart';
import 'package:rose_fz/models/databases/request_log.dart';
import 'package:rose_fz/utils/db.dart';

class HttpUtil {
  static HttpUtil instance;
  Dio dio;
  Map<String, dynamic> headers = new Map();

  static HttpUtil getInstance() {
    if (instance == null) {
      instance = new HttpUtil();
    }
    return instance;
  }

  HttpUtil() {
    // headers['Cookie'] =
    // "pgv_pvi=8212383744;pgv_si=s2870858752;ptisp=cnc;ptui_loginuin=519872449;uin=o0519872449;skey=@5srNZnwTx;RK=wHTNzn9tSz;ptcz=0a16b4e9c5c710f1bc0c4b3a76bb93c486318c241c6f0cda93652b50c4f1dc4f";
    headers['Referer'] =
        "https://qqgamecdnimg.qq.com/cdn/swf_0908/roseFrame_v6363.swf";

    dio = new Dio();
    dio.options.contentType = 'application/x-www-form-urlencoded';
    dio.options.responseType = ResponseType.bytes;
  }

  // get(url, {data, options, cancelToken}) async {
  //   print('get请求启动! url：$url ,body: $data');
  //   Response response;
  //   try {
  //     response = await dio.get(
  //       url,
  //       data: data,
  //       cancelToken: cancelToken,
  //     );
  //     print('get请求成功!response.data：${response.data}');
  //   } on DioError catch (e) {
  //     if (CancelToken.isCancel(e)) {
  //       print('get请求取消! ' + e.message);
  //     }
  //     print('get请求发生错误：$e');
  //   }
  //   return response.data;
  // }

  post(method, {data}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String cookies = sharedPreferences.getString('cookies');
    headers['Cookie'] = cookies;
    Options options = Options(headers: headers);
//    print('post请求启动! url：$url ,body: $data');
    Response response;
    try {
      var url =
          'https://cgi.meigui.qq.com/cgi-bin/$method?gprand=${Random().nextDouble()}';
      response = await dio.post(url, data: data, options: options);
      String res = gbk.decode(response.data);
      int pos = -1;
      while ((pos = res.indexOf("\\x")) != -1) {
        String temp = res.substring(pos, pos + 4);
        res = res.replaceAll(
            temp, String.fromCharCode(int.parse(temp.substring(2), radix: 16)));
      }
      res = res.replaceAll('\n', ' ');
      var result = json.decode(res);
      var db = DBUtil();
      RequestLog log = new RequestLog();
      log.url = url;
      log.params = data.toString();
      log.response = res;
      log.result = result['result'];
      log.resultStr = result['resultstr'];
      log.uin = UinCrypt.decryptUin('${User.userInfo?.uin}');
      log.time = DateTime.now().toString();

      await db.addRequestLog(log);

      // sleep(Duration(seconds: 1));

      return result;
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('post请求取消! ' + e.message);
      }
      print('post请求发生错误：$e');
    } on Error catch (e) {
      print('post请求发生错误：$e');
    }
  }
}
