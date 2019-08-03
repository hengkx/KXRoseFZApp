import 'package:KXRoseFZApp/config.dart';
import 'package:KXRoseFZApp/utils/mg.dart';
import 'package:KXRoseFZApp/widgets/round_rect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpinyin/lpinyin.dart';

import '../soil.dart';

// import '../utils/mg.dart';

class SelectFlowerPage extends StatefulWidget {
  final Soil soil;
  SelectFlowerPage({Key key, @required this.soil}) : super(key: key);
  @override
  _SelectFlowerPageState createState() => _SelectFlowerPageState(this.soil);
}

class Flower {
  final int plantId;
  final int seedId;

  /// 1 水生 2 藤类 3 仙藤 99 陆植 100 玫瑰
  final int type;
  final int seedPrice;
  final int seedPriceQPoint;
  int count;
  final String name;
  final String pyName;

  Flower({
    this.plantId,
    this.seedId,
    this.type,
    this.seedPrice,
    this.count,
    this.seedPriceQPoint,
    this.pyName,
    this.name,
  });

  String getTypeName() {
    switch (type) {
      case 1:
        return "水生";
      case 2:
        return "藤类";
      case 3:
        return "仙藤";
      case 99:
        return "陆植";
      case 100:
        return "玫瑰";
    }
    return "";
  }

  bool isBuy() {
    return seedPrice != 0 || seedPriceQPoint != 0;
  }
}

class _SelectFlowerPageState extends State<SelectFlowerPage> {
  _SelectFlowerPageState(this.soil);

  final Soil soil;

  List<Flower> flowers = new List<Flower>();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Config.init();
    dynamic initFirstRes = await MGUtil.getInitFirst();
    Config.flowerConfig.findAllElements("item").forEach((item) {
      var plantId = int.parse(item.getAttribute("id"));
      if (item.getAttribute("combineid") == null && plantId != 0) {
        int type = int.parse(item.getAttribute("type") ?? "99");
        int potLevel = int.parse(item.getAttribute("potLevel") ?? "0");
        int season = int.parse(item.getAttribute("season") ?? "0");
        var seedId = int.parse(item.getAttribute("seedID"));
        int count = initFirstRes['vegetableseed$seedId'] ?? 0;
        int seedPrice = int.parse(item.getAttribute("seedPrice"));
        if ((count > 0 || seedPrice > 0) &&
            ((soil.type == 1 && type == 1 && soil.potLevel >= potLevel) ||
                (soil.type == 3 &&
                    soil.hanglevel < 4 &&
                    type == 3 &&
                    potLevel <= soil.hanglevel) ||
                (soil.type == 3 &&
                    soil.hanglevel == 4 &&
                    (type == 2 || type == 3 || (type == 99 && season < 4))) ||
                (soil.type == 0 &&
                    (type == 2 ||
                        type == 100 ||
                        (type == 99 && soil.potLevel >= potLevel))))) {
          var name = item.getAttribute("name");
          flowers.add(new Flower(
            plantId: plantId,
            seedId: seedId,
            type: type,
            seedPrice: seedPrice,
            seedPriceQPoint: int.parse(item.getAttribute("seedPriceQPoint")),
            pyName: PinyinHelper.getShortPinyin(name),
            name: name,
            count: count,
          ));
        }
      }
    });
    if (soil.type == 0 || soil.hanglevel == 4) {
      Config.roseConfig.findAllElements("item").forEach((item) {
        var plantId = int.parse(item.getAttribute("id"));
        var seedId = int.parse(item.getAttribute("materials").split(",")[0]);
        int count = initFirstRes['roseseed$seedId'] ?? 0;
        if (count > 0 &&
            item.getAttribute("combineid") == null &&
            plantId != 0) {
          var name = item.getAttribute("name");
          flowers.add(new Flower(
            plantId: plantId,
            seedId: seedId,
            type: 100,
            seedPrice: int.parse(item.getAttribute("seedPrice")),
            seedPriceQPoint: int.parse(item.getAttribute("seedPriceQPoint")),
            pyName: PinyinHelper.getShortPinyin(name),
            name: name,
            count: initFirstRes['roseseed$seedId'] ?? 0,
          ));
        }
      });
    }

    flowers.sort((a, b) => a.pyName.compareTo(b.pyName));
    this.setState(() {
      flowers = flowers;
    });
  }

  final TextEditingController controller = TextEditingController();

  Color getTypeColor(int type) {
    switch (type) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.purple;
      case 3:
        return Colors.orange;
      case 99:
        return Colors.brown[900];
      case 100:
        return Colors.red;
    }
    return Colors.red;
  }

  final numController = TextEditingController();
  showSnackBar(String tip) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(tip),
      duration: Duration(milliseconds: 1000),
    ));
  }

  buySeed(Flower flower, int count) async {
    if (count <= 0) {
      return;
    }
    int times = count ~/ 99;
    int buyCount = times > 0 ? 99 : count % 99;
    var res = await MGUtil.buySeed(flower.seedId, buyCount);
    if (res.result == 0) {
      showSnackBar("购买 ${flower.name} 种子 $buyCount 个 成功");
      flower.count += buyCount;
      setState(() {});
      if (count - buyCount > 0) {
        await buySeed(flower, count - buyCount);
        return;
      }
    } else {
      showSnackBar(res.resultstr);
    }
  }

  void showBuyDialog(BuildContext context, Flower flower) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('购买 ${flower.name} 种子'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                    autofocus: true,
                    controller: numController,
                    decoration: new InputDecoration(labelText: "请输入需要购买的数量"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp("[0-9]")),
                    ]),
              ],
            ),
          ),
          actions: <Widget>[
            OutlineButton(
              child: Text(
                '取消',
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                '购买',
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                buySeed(flower, int.parse(numController.text));
                numController.text = "";
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return new SimpleDialog(
    //         title: new Text("购买鲜花种子"),
    //         children: <Widget>[
    //           Container(
    //             child:,
    //           )
    //         ],
    //       );
    //     });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("选择种子"),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              // new Container(
              //   // color: Theme.of(context).primaryColor,
              //   child: new Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: new Card(
              //       child: new ListTile(
              //         leading: new Icon(Icons.search),
              //         title: new TextField(
              //           controller: controller,
              //           // decoration: new InputDecoration(
              //           //     hintText: 'Search', border: InputBorder.none),
              //           // onChanged: onSearchTextChanged,
              //         ),
              //         trailing: new IconButton(
              //           icon: new Icon(Icons.cancel),
              //           onPressed: () {
              //             controller.clear();
              //             // onSearchTextChanged('');
              //           },
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    var flower = flowers[index];
                    final List<Widget> actions = [];
                    if (flower.seedPrice != 0) {
                      actions.add(OutlineButton(
                        // color: Colors.redAccent.shade200,
                        textColor: Theme.of(context).primaryColor,
                        // color: Theme.of(context).primaryColor,
                        child: new Text('购买'),
                        onPressed: () => showBuyDialog(context, flower),
                      ));
                    }
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      RoundRect(
                                        text: flower.getTypeName(),
                                        color: getTypeColor(flower.type),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              flower.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            "数量：${flower.count} 种子价格：${flower.seedPrice}",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: actions,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop(flower);
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return new Container(height: 1.0, color: Colors.grey[300]);
                  },
                  itemCount: flowers.length,
                ),
              ),
            ],
          ),
        ));
  }
}
