import 'package:KXRoseFZApp/config.dart';
import 'package:KXRoseFZApp/widgets/round_rect.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';

// import '../utils/mg.dart';

class SelectFlowerPage extends StatefulWidget {
  final dynamic initFirstRes;
  SelectFlowerPage({Key key, @required this.initFirstRes}) : super(key: key);
  @override
  _SelectFlowerPageState createState() => _SelectFlowerPageState(initFirstRes);
}

class Flower {
  final int plantId;
  final int seedId;
  final int type; // 1 水生 2 藤类 3 仙藤 99 陆植 100 玫瑰
  final int seedPrice;
  final int seedPriceQPoint;
  final int count;
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
  final dynamic initFirstRes;

  _SelectFlowerPageState(this.initFirstRes);

  List<Flower> flowers = new List<Flower>();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Config.init();
    Config.flowerConfig.findAllElements("item").forEach((item) {
      var plantId = int.parse(item.getAttribute("id"));
      if (item.getAttribute("combineid") == null && plantId != 0) {
        var name = item.getAttribute("name");
        var seedId = int.parse(item.getAttribute("seedID"));
        flowers.add(new Flower(
          plantId: plantId,
          seedId: seedId,
          type: item.getAttribute("type") != null
              ? int.parse(item.getAttribute("type"))
              : 99,
          seedPrice: int.parse(item.getAttribute("seedPrice")),
          seedPriceQPoint: int.parse(item.getAttribute("seedPriceQPoint")),
          pyName: PinyinHelper.getShortPinyin(name),
          name: name,
          count: initFirstRes['vegetableseed$seedId'] ?? 0,
        ));
      }
    });
    flowers.sort((a, b) => a.pyName.compareTo(b.pyName));
    this.setState(() {
      flowers = flowers;
    });
  }

  TextEditingController controller = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("选择花"),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              new Container(
                // color: Theme.of(context).primaryColor,
                child: new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Card(
                    child: new ListTile(
                      leading: new Icon(Icons.search),
                      title: new TextField(
                        controller: controller,
                        // decoration: new InputDecoration(
                        //     hintText: 'Search', border: InputBorder.none),
                        // onChanged: onSearchTextChanged,
                      ),
                      trailing: new IconButton(
                        icon: new Icon(Icons.cancel),
                        onPressed: () {
                          controller.clear();
                          // onSearchTextChanged('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    var flower = flowers[index];
                    return GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(children: <Widget>[
                          Row(
                            children: <Widget>[
                              RoundRect(
                                text: flower.getTypeName(),
                                color: getTypeColor(flower.type),
                              ),
                              Expanded(
                                child: Text(
                                  flower.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              flower.isBuy()
                                  ? RoundRect(
                                      text: "可买",
                                      color: Colors.orange[900],
                                    )
                                  : Container(),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "数量：${flower.count}",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
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
