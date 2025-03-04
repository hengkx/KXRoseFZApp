import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rose_fz/global.dart';
import 'package:rose_fz/models/flower.dart';
import 'package:rose_fz/models/soil.dart';
import 'package:rose_fz/user.dart';
import 'package:rose_fz/utils/mg.dart';
import 'package:rose_fz/utils/plant.dart';
import 'package:rose_fz/utils/xml.dart';
import 'package:rose_fz/widgets/round_rect.dart';

class SelectFlowerPage extends StatefulWidget {
  final Soil soil;
  SelectFlowerPage({Key key, this.soil}) : super(key: key);
  @override
  _SelectFlowerPageState createState() => _SelectFlowerPageState(this.soil);
}

class _SelectFlowerPageState extends State<SelectFlowerPage> {
  _SelectFlowerPageState(this.soil);

  final Soil soil;

  List<Flower> flowers = [];
  List<Flower> showFlowers = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  final List<String> filters = [];

  init() async {
    await Global.init();
    User.initFirstRes = await MGUtil.getInitFirst();
    for (var item in Global.config['flower'].findAllElements("item")) {
      var flower = XML.toFlower(item);
      int count = User.initFirstRes.warehouse[flower.plantId] ?? 0;
      flower.count = count;
      if (PlantUtil.isPlant(flower, soil)) {
        flowers.add(flower);
      }
    }
    if (soil == null || soil.type == 0 || soil.hanglevel == 4) {
      for (var item in Global.config['rose'].findAllElements("item")) {
        var flower = XML.toFlower(item);
        int count = User.initFirstRes.warehouse[flower.plantId] ?? 0;
        flower.type = 100;
        flower.count = count;
        if (PlantUtil.isPlant(flower, soil)) {
          flowers.add(flower);
        }
      }
    }
    flowers.sort((a, b) => a.pyName.compareTo(b.pyName));
    for (var item in flowers) {
      var str = item.pyName[0].toUpperCase();
      if (filters.indexOf(str) == -1) {
        filters.add(str);
      }
    }
    this.setState(() {
      flowers = flowers;
      showFlowers = flowers;
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

  handleSearchTextChanged(val) {
    if (val == '') {
      showFlowers = flowers;
    } else {
      showFlowers = flowers
          .where((item) =>
              (item.name.indexOf(val) != -1 || item.pyName.indexOf(val) != -1))
          .toList();
    }
    setState(() {});
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final List<Widget> filterWidgets = [];
    for (var item in filters) {
      filterWidgets.add(Text(item));
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("选择种子"),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            Expanded(
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
                            decoration: new InputDecoration(
                                hintText: '请输入名称或拼音简写',
                                border: InputBorder.none),
                            onChanged: handleSearchTextChanged,
                          ),
                          trailing: new IconButton(
                            icon: new Icon(Icons.cancel),
                            onPressed: () {
                              controller.clear();
                              handleSearchTextChanged('');
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        var flower = showFlowers[index];
                        final List<Widget> actions = [];
                        if (flower.seedPrice != 0) {
                          actions.add(OutlineButton(
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
                                                style: TextStyle(
                                                    color: Colors.grey),
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
                        return new Container(
                            height: 1.0, color: Colors.grey[300]);
                      },
                      itemCount: showFlowers.length,
                    ),
                  ),
                ],
              ),
            ),
            // Center(
            //   child: Container(
            //     width: 50,
            //     height: 50,
            //     decoration: BoxDecoration(
            //       color: Colors.grey[400],
            //       borderRadius: BorderRadius.all(Radius.circular(10)),
            //     ),
            //     child: Center(
            //       child: Text(
            //         "A",
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // IndexBar(
            //   onTouch: (IndexBarDetails details) {
            //     print(details.tag);
            //   },
            // ),
            // GestureDetector(
            //   onVerticalDragDown: (DragDownDetails details) {
            //     print(details.localPosition.dy);
            //   },
            //   onVerticalDragUpdate: (DragUpdateDetails details) {
            //     print(details.localPosition.dy);
            //   },
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 5),
            //     alignment: Alignment.center,
            //     color: Colors.red,
            //     child: Column(
            //       children: <Widget>[
            //         Expanded(
            //           child: Container(),
            //         ),
            //         Column(
            //           children: filterWidgets,
            //         ),
            //         Expanded(
            //           child: Container(),
            //         ),
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
