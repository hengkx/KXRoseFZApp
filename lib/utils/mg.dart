import 'package:KXRoseFZApp/utils/http.dart';
import 'package:KXRoseFZApp/widgets/plant.dart';
import 'package:intl/intl.dart';

import '../response.dart';
import '../soil.dart';

class MGUtil {
  static Future<GetUserInfoResponse> getUserInfo() async {
    var data = await HttpUtil.getInstance()
        .post("rosary0908_get_user_info", data: {"benew0908": 1});
    return GetUserInfoResponse.fromJson(data);
  }

  static Future<dynamic> getInitFirst() async {
    var params = {
      "selforfriend": 0,
      "common": 1,
      "ossType": 3,
      "benew0908": 5,
      "cgiVersion": 43,
    };
    var res = await HttpUtil.getInstance()
        .post("rosary0909_get_init_first_self", data: params);
    return res;
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
}
