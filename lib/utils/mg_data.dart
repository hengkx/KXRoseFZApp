import 'package:rose_fz/global.dart';
import 'package:rose_fz/models/responses/award.dart';
import 'package:xml/xml.dart';

class MGInfo {
  int id;
  int localId;
  String name;
  String type;
  String unit;
  String desc;
  XmlElement data;
  MGInfo({
    this.id,
    this.localId,
    this.name,
    this.type,
    this.unit,
    this.desc,
    this.data,
  });
}

class MGDataUtil {
  static String getPropItemName(Award award) {
    String name = '';

    switch (award.type) {
      case 0:
        var propConfig = getInfoByID(award.id);
        if (propConfig != null) {
          name = propConfig.name;
        } else {
          name = '未知道具';
          // Global.logger.debug(((('未知道具: type:' + prop.type) + ' id:') + prop.id));
        }
        break;
      case 4:
        name = '经验值';
        break;
      case 5:
        name = '魅力值';
        break;
      case 6:
        name = '金币';
        break;
      case 13:
        name = '点丁香好感度';
        break;
      case 14:
        name = 'Q币';
        break;
      case 7:
      case 8:
      case 9:
        name = award.name;
        break;
      case 16:
        if (award.id < 141049000) {
          name = Global.config['shelf']['decorate'][award.id].name;
        } else {
          name = Global.config['shelf']['patch'][award.id].name;
        }
        break;
      default:
        name = '未知道具';
        break;
    }
    return name;
  }

  static Map<String, MGInfo> dicMapId = Map();

  static void initInfoMap() {
    dicMapId['1000'] = MGInfo(id: 1000, name: '魅力值', type: 'charm', unit: '点');
    dicMapId['1001'] = MGInfo(id: 1000, name: '金币', type: 'coin', unit: '');
    dicMapId['1003'] = MGInfo(id: 1000, name: '经验', type: 'exp', unit: '');
    dicMapId['1004'] =
        MGInfo(id: 1000, name: '经营值', type: 'marketexp', unit: '点');
    dicMapId['1005'] =
        MGInfo(id: 1000, name: '装饰度', type: 'marketdecorate', unit: '');
    dicMapId['9001'] =
        MGInfo(id: 1000, name: '礼炮幸运点', type: 'luckypoint', unit: '点');
    dicMapId['9002'] =
        MGInfo(id: 1000, name: '双倍魅力加长', type: 'doublecharm', unit: '');

    for (var item in Global.config['flower'].findAllElements('item')) {
      var id = int.parse(item.getAttribute('id'));
      var name = item.getAttribute('name');
      var unit = item.getAttribute('unit');
      var desc = item.getAttribute('flowerdescrible');
      dicMapId['$id'] = MGInfo(
        id: id,
        name: name,
        type: 'flower',
        unit: unit,
        desc: desc,
        localId: id,
        data: item,
      );

      var seedId = int.parse(item.getAttribute('seedID'));
      if (seedId > 0) {
        dicMapId['$seedId'] = MGInfo(
          id: seedId,
          name: '$name种子',
          type: 'flowerseed',
          unit: '颗',
          localId: seedId,
          data: item,
        );
      }
    }
    for (var item
        in Global.config['variationFlowerSeed'].findAllElements('item')) {
      var name = item.getAttribute('name');
      var seedId = int.parse(item.getAttribute('seedID'));
      if (seedId > 0) {
        dicMapId['$seedId'] = MGInfo(
          id: seedId,
          name: '$name种子',
          type: 'flowerseed',
          unit: '颗',
          localId: seedId,
          data: item,
        );
      }
    }
    for (var item in Global.config['rose'].findAllElements('item')) {
      var id = int.parse(item.getAttribute('id'));
      var name = item.getAttribute('name');
      var svrId = item.getAttribute('svrID');
      if (svrId != null) {
        dicMapId[svrId] = MGInfo(
          id: int.parse(svrId),
          name: name,
          type: 'rose',
          unit: '朵',
          localId: id,
          data: item,
        );
      } else {
        dicMapId['$id'] = MGInfo(
          id: id,
          name: name,
          type: 'rose',
          unit: '朵',
          localId: id,
          data: item,
        );
      }
    }
    for (var item in Global.config['charmLevels']
        .findAllElements('charmflower')
        .toList()[0]
        .findAllElements('item')) {
      var id = int.parse(item.getAttribute('id'));
      var name = item.getAttribute('name');
      var svrId = item.getAttribute('svrID');
      if (svrId != null) {
        if (int.parse(svrId) != -1) {
          dicMapId[svrId] = MGInfo(
            id: int.parse(svrId),
            name: name,
            type: 'charmflower',
            unit: '束',
            localId: id,
            data: item,
          );
        }
      } else {
        dicMapId['$id'] = MGInfo(
          id: id,
          name: name,
          type: 'charmflower',
          unit: '束',
          localId: id,
          data: item,
        );
      }
    }

    for (var item in Global.config['meterial'].findAllElements('item')) {
      var id = int.parse(item.getAttribute('id'));
      var svrId = item.getAttribute('svrID');
      var mgInfo = MGInfo(
        name: item.getAttribute('name'),
        type: 'meterial',
        unit: item.getAttribute('unit'),
        localId: id,
        data: item,
      );
      if (svrId != null) {
        if (int.parse(svrId) != -1) {
          mgInfo.id = int.parse(svrId);
        }
      } else {
        mgInfo.id = id;
      }
      if (mgInfo.id != null) {
        dicMapId['${mgInfo.id}'] = mgInfo;
      }
    }

    for (var item in Global.config['prop'].findAllElements('item')) {
      var id = int.parse(item.getAttribute('id'));
      var svrId = item.getAttribute('svrID');
      var mgInfo = MGInfo(
        name: item.getAttribute('name'),
        type: 'prop',
        unit: item.getAttribute('unit'),
        desc: item.getAttribute('info'),
        localId: id,
        data: item,
      );
      if (svrId != null) {
        if (int.parse(svrId) != -1) {
          mgInfo.id = int.parse(svrId);
        }
      } else {
        mgInfo.id = id;
      }
      if (mgInfo.id != null) {
        dicMapId['${mgInfo.id}'] = mgInfo;
        if (id >= 31005 && id <= 31009) {
          var colors = ['#008800', '#2990EC', '#B72B97', '#C4661A', '#D03135'];
          var index = id - 31005;
          mgInfo.name = "<font color='${colors[index]}'>${mgInfo.name}</font>";
        }
      }
    }

    for (var item in Global.config['petPK']
        .findAllElements('tokenConfig')
        .toList()[0]
        .findAllElements('item')) {
      var id = int.parse(item.getAttribute('id'));
      dicMapId['$id'] = MGInfo(
        name: item.getAttribute('name'),
        type: 'prop',
        unit: item.getAttribute('unit'),
        localId: id,
        data: item,
      );
    }
    for (var item in Global.config['petPK']
        .findAllElements('runesConfig')
        .toList()[0]
        .findAllElements('item')) {
      var id = int.parse(item.getAttribute('id'));
      dicMapId['$id'] = MGInfo(
        name: item.getAttribute('name'),
        type: 'prop',
        unit: item.getAttribute('unit'),
        localId: id,
        data: item,
      );
    }
    for (var item in Global.config['otherProps'].findAllElements('item')) {
      var id = int.parse(item.getAttribute('id'));
      dicMapId['$id'] = MGInfo(
        name: item.getAttribute('name'),
        type: 'prop',
        unit: item.getAttribute('unit'),
        localId: id,
        data: item,
      );
    }
    for (var item in Global.config['bouquet'].findAllElements('item')) {
      var id = int.parse(item.getAttribute('id'));
      var svrId = item.getAttribute('svrID');
      var mgInfo = MGInfo(
        name: item.getAttribute('name'),
        type: 'bouquet',
        unit: item.getAttribute('unit'),
        localId: id,
        data: item,
      );
      if (svrId != null) {
        if (int.parse(svrId) != -1) {
          mgInfo.id = int.parse(svrId);
        }
      } else {
        mgInfo.id = id;
      }
      if (mgInfo.id != null) {
        dicMapId['${mgInfo.id}'] = mgInfo;
      }
    }
    for (var item in Global.config['decoration'].findAllElements('item')) {
      var id = int.parse(item.getAttribute('id'));
      var mgInfo = MGInfo(
        id: id,
        name: item.getAttribute('name'),
        type: 'decrate',
        unit: '个',
        desc: item.getAttribute('info'),
        localId: id,
        data: item,
      );
      if (!dicMapId.containsKey('${mgInfo.id}')) {
        dicMapId['${mgInfo.id}'] = mgInfo;
      }
    }
  }

  // static MGInfo getInfoByID(int id, [bool needCount = false]) {
  static MGInfo getInfoByID(int id) {
    var item;
    if (id == 0) {
      return null;
    }

    item = dicMapId['$id'];
    // if (item != null && needCount) {
    //   // need.count = this.getCountByID(id);
    // }

    return item;
  }

  static int getPlantIDBySeedId(int id) {
    var xml = Global.config['flower']
        .findAllElements('item')
        .where((xe) => xe.getAttribute('seedID') == '$id')
        .toList();
    if (xml.length > 0) {
      return int.parse(xml[0].getAttribute('id'));
    }
    xml = Global.config['meterial']
        .findAllElements('seeds')
        .toList()[0]
        .findAllElements('item')
        .where((xe) => xe.getAttribute('seedID') == '$id')
        .toList();
    if (xml.length > 0) {
      return int.parse(xml[0].getAttribute('id'));
    }
    return 0;
  }

  static int getCountByID(int id) {
    //           var _local_2:Object;
    //           var _local_3:String;
    //           var localId:int;
    var mgInfo = getInfoByID(id);
    if (mgInfo == null) {
      return 0;
    }
    //           _local_3 = _local_2.type;
    var localId = mgInfo.localId;
    switch (mgInfo.type) {
      //               case 'exp':
      //                   return (Number(this.m_myUserInfo.experice));
      //               case 'charm':
      //                   return (int(this.m_myUserInfo.charmtotal));
      //               case 'coin':
      //                   return (int(this.m_myUserInfo.rosemoney));
      //               case 'flower':
      //                   return (int(this.m_gainData.flower[localId]));
      //               case 'rose':
      //                   return (int(this.m_gainData.rose[localId]));
      // case 'flowerseed':
      // localId = getPlantIDBySeedId(localId);
      //                   return (int(this.m_seedData.flower[localId]));
      //               case 'roseseed':
      //                   localId = this.getPlantIDBySeedId(int(localId));
      //                   return (int(this.m_seedData.rose[localId]));
      //               case 'meterial':
      //                   if (((id >= 110) && (id < 22001)))
      //                   {
      //                       return (int(this.m_meterialData[localId]));
      //                   };
      //                   return (int(this.m_seedData.rose[localId]));
      //               case 'prop':
      //                   return (int(this.m_propsData[localId]));
      default:
        return -1;
    }
  }
}
