import 'package:rose_fz/models/responses/talent_pk_response.dart';
import 'package:rose_fz/models/soil.dart';
import 'package:rose_fz/utils/mg_data.dart';

import './http.dart';
import 'package:intl/intl.dart';

import '../response.dart';

class MGUtil {
  static Future<GetUserInfoResponse> getUserInfo() async {
    var data = await HttpUtil.getInstance()
        .post("rosary0908_get_user_info", data: {"benew0908": 1});
    return GetUserInfoResponse.fromJson(data);
  }

  static Future<GetInitFirstResponse> getInitFirst() async {
    var params = {
      "selforfriend": 0,
      "common": 1,
      "ossType": 3,
      "benew0908": 5,
      "cgiVersion": 43,
    };
    var res = await HttpUtil.getInstance()
        .post("rosary0909_get_init_first_self", data: params);
    var response = GetInitFirstResponse.fromJson(res);

// 免费玫瑰种子个数
    response.roseseed[998] = res['freeseedcount'];

    res.forEach((key, value) {
      if (key.contains('vegetableseed') || key.contains('roseseed')) {
        var id = int.parse(
            key.replaceAll('vegetableseed', '').replaceAll('roseseed', ''));
        response.warehouse[MGDataUtil.getPlantIDBySeedId(id)] = value;
      }
      // 鲜花
      if (key.contains('vegetablefruit')) {
        var id = int.parse(key.replaceAll('vegetablefruit', ''));
        response.vegetablefruit[id] = value;
      }
      // 玫瑰原料
      else if (key.contains('roseseed') ||
          RegExp(r"^meterial\d+$").hasMatch(key)) {
        var id = int.parse(
            key.replaceAll('roseseed', '').replaceAll('meterial', ''));
        response.roseseed[id] = value;
      }
      // 玫瑰
      else if (RegExp(r"^rose\d+$").hasMatch(key)) {
        var id = int.parse(key.replaceAll('rose', ''));
        if (id > 14) {
          response.rose[id] = value[0];
        } else if (id <= 12) {
          response.roseseed[id] = value[0];
        }
      }
      // 特殊道具
      else if (key.contains('prop')) {
        var id = int.parse(key.replaceAll('prop', ''));
        if (value > 0) {
          response.prop[id] = value;
        }
      }
    });
    return response;
  }

  /// type 1 杀虫 2 晒阳光 3 除草
  static Future<BaseResponse> plantAction(int no, int type) async {
    var params = {
      "soilno": no,
      "actiontype": type,
      "ossType": 6,
      "benew0908": 2,
      "cgiVersion": 43,
    };
    var res = await HttpUtil.getInstance()
        .post("rosary0904_plant_action", data: params);
    return BaseResponse.fromJson(res);
  }

  static final dateFomarDate = DateFormat("yyyy-MM-dd");

  static Future<BaseResponse> buySeed(int type, int count) async {
    var params = {
      "type": type,
      "count": count,
      "etime": DateTime.parse(dateFomarDate.format(DateTime.now()))
              .add(Duration(days: 1, seconds: -1))
              .millisecondsSinceEpoch ~/
          1000,
      "ossType": 6,
      "benew0908": 1,
      "cgiVersion": 43,
    };
    var res = await HttpUtil.getInstance()
        .post("rosary0908_rosemoney_buy_seed", data: params);
    return BaseResponse.fromJson(res);
  }

  static Future<UseFertilizerResponse> useFertilizer(int no, int type) async {
    var params = {
      "usetype": type,
      "soilno": no,
      "benew0908": 1,
      "cgiVersion": 43,
    };
    var res = await HttpUtil.getInstance()
        .post("rosary0906_use_fertilizer", data: params);
    return UseFertilizerResponse.fromJson(res);
  }

  static Future<BaseResponse> exchange(int type) async {
    var params = {
      "materialtype": type,
      "benew0908": 1,
      "cgiVersion": 43,
    };
    var res = await HttpUtil.getInstance()
        .post("rosary0903_exchange_crowry", data: params);
    return BaseResponse.fromJson(res);
  }

  static Future<PlantResponse> plant(int no, int id) async {
    var params = {
      "soilno": no,
      "rosetype": id,
      "ossType": 4,
      "benew0908": 2,
      "cgiVersion": 43,
    };
    var res = await HttpUtil.getInstance()
        .post("rosary0904_soil_plant_rose", data: params);
    return PlantResponse.fromJson(res);
  }

  static Future<GainResponse> gain(int no) async {
    var params = {
      "soilno": no,
      "ossType": 5,
      "flag": 0,
      "benew0908": 8,
      "version": 1,
      "cgiVersion": 43,
    };
    var res =
        await HttpUtil.getInstance().post("rosary0904_gain", data: params);
    return GainResponse.fromJson(res);
  }

  static Future<HoeResponse> hoe(int no) async {
    var params = {
      "soilno": no,
      "ossType": 7,
      "benew0908": 2,
      "ver": 1,
      "cgiVersion": 43,
    };
    var res = await HttpUtil.getInstance().post("rosary0904_hoe", data: params);
    return HoeResponse.fromJson(res);
  }

  static Future<List<Soil>> getPlantInfo() async {
    var params = {
      "selforfriend": 0,
      "benew0908": 1,
      "cgiVersion": 43,
      "ossType": 2
    };
    var res = await HttpUtil.getInstance()
        .post("rosary0908_get_plant_info_self", data: params);
    List<Soil> soils = [];
    if (res['result'] == 0) {
      for (var i = 1; i <= res["soilcount"]; i++) {
        Soil soil = new Soil(res["soil$i"][0]);
        soil.no = i;
        soils.add(soil);
      }
    }

    return soils;
  }

  static Future<TaskResponse> getTasks() async {
    var params = {
      "index": -1,
      "tasktype": 0,
      "benew0908": 1,
      "cgiVersion": 43,
    };
    var res = await HttpUtil.getInstance().post("rosary_task", data: params);
    return TaskResponse.fromJson(res);
  }

  static Future<dynamic> activityOper(dynamic otherParmas) async {
    var params = {
      "benew0908": 1,
      "cgiVersion": 43,
    };
    params.addAll(otherParmas);
    var res =
        await HttpUtil.getInstance().post("rosary_activity_oper", data: params);
    return res;
  }

  static Future<TalentPKResponse> talentPKOper(
      Map<String, int> otherParmas) async {
    var params = {
      "benew0908": 1,
      "cgiVersion": 43,
    };
    params.addAll(otherParmas);
    var res =
        await HttpUtil.getInstance().post("rosary_talentpk_oper", data: params);
    return TalentPKResponse.fromJson(res);
  }
}
