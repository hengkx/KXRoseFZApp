import 'package:KXRoseFZApp/utils/http.dart';
import '../response.dart';
import '../soil.dart';

class MGUtil {
  static Future<GetUserInfoResponse> getUserInfo() async {
    var data = await HttpUtil.getInstance()
        .post("rosary0908_get_user_info", data: {"benew0908": 1});
    return GetUserInfoResponse.fromJson(data);
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

  static Future<List<Soil>> getPlantInfo() async {
    var params = {
      "selforfriend": 0,
      "benew0908": 1,
      "cgiVersion": 43,
      "ossType": 2
    };
    var res = await HttpUtil.getInstance()
        .post("rosary0908_get_plant_info_self", data: params);
    List<Soil> soils = new List<Soil>();
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
