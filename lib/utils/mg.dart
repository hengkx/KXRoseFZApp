import 'package:KXRoseFZApp/utils/http.dart';
import '../response.dart';

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
}
