import 'dart:math';
import 'package:rose_fz/models/pet_pk.dart';
import 'package:rose_fz/models/responses/award.dart';
import 'package:rose_fz/models/responses/talent_pk_response.dart';
import 'package:rose_fz/utils/mg_data.dart';

import '../response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../utils/mg.dart';
import '../global.dart';

final dateFormat = new DateFormat('MM-dd HH:mm');

class TalentPKPage extends StatefulWidget {
  @override
  _TalentPKState createState() {
    return new _TalentPKState();
  }
}

class TaskConfig {
  String name;
  String ruleDesc;
  String ruleTip;
  int ruleLen;
}

class _TalentPKState extends State<TalentPKPage> {
  TalentPKResponse talentPKResponse;
  List<PetPK> petPKs = [];
  PetPK selectPetPK;
  bool alwaysAdv = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Global.init();

    var res = await MGUtil.talentPKOper({'type': 1});
    for (var item
        in Global.config['petPKInstance'].findAllElements('instance')) {
      var index = int.parse(item.getAttribute('index'));
      if (index <= res.advProgress + 1) {
        petPKs.add(PetPK(
          index: index,
          stage: int.parse(item.getAttribute('stage')),
          name: item.getAttribute('name'),
        ));
      } else {
        break;
      }
    }

    setState(() {
      selectPetPK = petPKs.firstWhere(
          (item) => item.index == res.advProgress - res.advProgress % 5);
      talentPKResponse = res;
    });
  }

  showSnackBar(String tip) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(tip),
      duration: Duration(seconds: 1),
    ));
  }

  void showActivityOperAward(List<Award> awards) {
    for (var award in awards) {
      int id = award.id;
      int count = award.count;
      var mgInfo = MGDataUtil.dicMapId['$id'];
      showSnackBar(
          '获得 ${MGDataUtil.getPropItemName(award)} $count ${mgInfo?.unit ?? ''}');
    }
  }

  Future challenge(int index) async {
    var res = await MGUtil.talentPKOper({'type': 2, 'uin': 0, 'rival': index});
    if (res.result == 0) {
      showSnackBar('挑战${res.isWin == 1 ? '成功' : '失败'}');
      showActivityOperAward(res.award);
      setState(() {
        talentPKResponse = res;
      });
    } else {
      showSnackBar(res.resultstr);
    }
  }

  Future autoChallenge() async {
    var count = talentPKResponse?.cnum;
    for (var i = 0; i < count; i++) {
      await challenge(Random().nextInt(10) + 1);
    }
  }

  selectPetPKPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            var petPK = petPKs[petPKs.length - index - 1];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                      child: Text(petPK.index.toString()),
                    ),
                    Expanded(
                      child: Text(
                        petPK.name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 50,
                      child: Text(
                        petPK.stage.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context, petPK);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Container(height: 1.0, color: Colors.grey[300]);
          },
          itemCount: petPKs.length,
        );
      },
    ).then((val) {
      if (val != null) {
        setState(() {
          selectPetPK = val;
        });
      }
    });
  }

  adventure() async {
    var count = talentPKResponse?.advNum;
    if (!alwaysAdv) {
      count = count > 1 ? 1 : 0;
    }
    for (var i = 0; i < count; i++) {
      var res =
          await MGUtil.talentPKOper({'type': 18, 'index': selectPetPK.index});
      if (res.result == 0) {
        showSnackBar('冒险${res.isWin == 1 ? '成功' : '失败'}');
        showActivityOperAward(res.award);
        setState(() {
          talentPKResponse?.advNum--;
        });
      } else {
        showSnackBar(res.resultstr);
      }
    }
  }

  handleOneKeyPressed() async {
    if (talentPKResponse.free == 0) {
      // 免费占卜
      await MGUtil.talentPKOper({'augury': 1, 'type': 24});
    }
    if (talentPKResponse.selfAward == 1) {
      // 领取奖励
      var r = await MGUtil.talentPKOper({'type': 11});
      showActivityOperAward(r.award);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: new Text('一键完成占卜、领奖、训练、战旗、提升品质、契约'),
                  onPressed: handleOneKeyPressed,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Container(
                height: 30,
                child: OutlineButton(
                  child: Text('${selectPetPK?.name}(${selectPetPK?.stage})'),
                  onPressed: selectPetPKPressed,
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: Text('连续执行'),
                  value: alwaysAdv,
                  onChanged: (bool val) {
                    setState(() {
                      alwaysAdv = val;
                    });
                  },
                ),
              ),
              MaterialButton(
                height: 30,
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('冒险'),
                onPressed:
                    (talentPKResponse?.advNum ?? 0) > 0 ? adventure : null,
              ),
            ],
          ),
        ),
        Container(height: 1.0, color: Colors.grey[300]),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Text('当前排名：'),
              Expanded(
                child: Text(
                  '${talentPKResponse?.selfRank ?? ''}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text('剩余次数：'),
              Expanded(
                child: Text(
                  '${talentPKResponse?.cnum ?? ''}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              MaterialButton(
                height: 30,
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('自动挑战'),
                onPressed:
                    (talentPKResponse?.cnum ?? 0) > 0 ? autoChallenge : null,
              ),
            ],
          ),
        ),
        Container(height: 1.0, color: Colors.grey[300]),
        Expanded(
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              var rival = talentPKResponse?.rivals[9 - index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Text(rival.rank.toString()),
                    Expanded(
                      child: Text(
                        rival.nickname,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    MaterialButton(
                      height: 30,
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text('挑战'),
                      onPressed: (talentPKResponse?.cnum ?? 0) > 0
                          ? () {
                              challenge(10 - index);
                            }
                          : null,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Container(height: 1.0, color: Colors.grey[300]);
            },
            itemCount: talentPKResponse?.rivals?.length ?? 0,
          ),
        ),
      ],
    );
  }
}
