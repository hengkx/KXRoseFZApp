import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rose_fz/pages/one_key_login.dart';
import 'package:rose_fz/response.dart';
import 'package:rose_fz/store/objects/user_info.dart';
import 'package:rose_fz/user.dart';
import 'package:rose_fz/utils/mg.dart';
import 'package:rose_fz/utils/uin_crypt.dart';

class UserModel extends ChangeNotifier {
  UserInfo user = UserInfo();
  static const platform = const MethodChannel('rose.hengkx.com/qq');

  Future login(context) async {
    var qqLoginUrl = await platform.invokeMethod("getQQLoginUrl");
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => LoginPage(url: qqLoginUrl),
    ))
        .then((_) {
      getUserInfo();
    });
  }

  Future switchLogin(context) async {
    Navigator.of(context).pushNamed('/login').then((_) {
      getUserInfo();
    });
  }

  Future loadPlant() async {
    var data = await MGUtil.getPlantInfo();
    user.soils = data;

    notifyListeners();
  }

  Future<GetUserInfoResponse> getUserInfo() async {
    var res = await MGUtil.getUserInfo();
    if (res.result == 0) {
      var data = await MGUtil.getPlantInfo();
      user = UserInfo(
        name: res.usernic,
        uin: UinCrypt.decryptUin('${res.uin}'),
        soils: data,
      );
    }
    if (user != null && user.uin != null) {
      // LocalStorage.set('githubUserInfo', json.encode(user));
    }
    notifyListeners();
    return res;
  }

  clearUserInfo() {
    user = UserInfo();
    notifyListeners();
  }
}
