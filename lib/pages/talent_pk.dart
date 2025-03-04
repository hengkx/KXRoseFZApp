import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rose_fz/global.dart';
import 'package:rose_fz/models/pet_pk.dart';
import 'package:rose_fz/models/responses/award.dart';
import 'package:rose_fz/models/responses/talent_pk_response.dart';
import 'package:rose_fz/utils/mg.dart';
import 'package:rose_fz/utils/mg_data.dart';

class TalentPKPage extends StatefulWidget {
  @override
  _TalentPKState createState() {
    return new _TalentPKState();
  }
}

class _TalentPKState extends State<TalentPKPage> {
  TalentPKResponse talentPKResponse;
  List<PetPK> petPKs = [];
  PetPK selectPetPK;
  bool alwaysAdv = true;
  int advNum = 0;
  int challengeNum = 0;

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
      advNum = res.advNum;
      challengeNum = res.cnum;
      if (res.advProgress != 0) {
        selectPetPK = petPKs.firstWhere(
            (item) => item.index == res.advProgress - res.advProgress % 5);
      }
      talentPKResponse = res;
    });
  }

  showSnackBar(String tip) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(tip),
      duration: Duration(seconds: 1),
    ));
  }

  void showActivityOperAward(List<Award> awards, [String tip = '']) {
    if (awards != null) {
      List<String> tips = [];
      for (var award in awards) {
        int id = award.id;
        int count = award.count;
        var mgInfo = MGDataUtil.dicMapId['$id'];
        tips.add(
            '${MGDataUtil.getPropItemName(award)} $count ${mgInfo?.unit ?? ''}');
      }
      showSnackBar('$tip 获得 ${tips.join(',')}');
    }
  }

  List<Award> awards = [];
  int succCount = 0;
  int failCount = 0;
  Future challenge(int index) async {
    var res = await MGUtil.talentPKOper({'type': 2, 'uin': 0, 'rival': index});
    if (res.result == 0) {
      awards.addAll(res.award);
      if (res.isWin == 1) {
        succCount++;
      } else {
        failCount++;
      }
      setState(() {
        challengeNum--;
        talentPKResponse = res;
      });
    } else {
      showSnackBar(res.resultstr);
    }
  }

  Future autoChallenge() async {
    awards = [];
    var count = talentPKResponse?.cnum;
    for (var i = 0; i < count; i++) {
      await challenge(Random().nextInt(10) + 1);
    }
    showActivityOperAward(awards, '挑战执行完成 成功 $succCount 次 失败 $failCount 次 ');
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
        showActivityOperAward(res.award, '冒险${res.isWin == 1 ? '成功' : '失败'}');
        setState(() {
          advNum--;
        });
      } else {
        showSnackBar(res.resultstr);
      }
    }
  }

  /// 宝宝训练
  Future trainPet(int trainCount) async {
    Global.userConfig.trainPets.forEach((int key, int val) async {
      if (val != 0 && trainCount > 0) {
        var count = min(val, trainCount);
        for (var i = 0; i < count; i++) {
          var res = await MGUtil.talentPKOper({'type': 4, 'op': 1, 'id': key});
          if (res.result == 0) {
            showActivityOperAward(res.extraAward);
            trainCount--;
          } else {
            showSnackBar('宝宝训练 ${res.resultstr}');
          }
        }
      }
    });
  }

  /// 契约升级
  Future contractPet(int contactCount) async {
    Global.userConfig.contractPets.forEach((int key, int val) async {
      if (val != 0 && contactCount > 0) {
        var count = min(val, contactCount);
        for (var i = 0; i < count; i++) {
          var res = await MGUtil.talentPKOper({
            'type': 23,
            'count': 1,
            'paytype': 1,
            'request': 2,
            'upgrade': 1,
            'pet': key
          });
          if (res.result == 0) {
            contactCount--;
          } else {
            showSnackBar('契约训练 ${res.resultstr}');
          }
        }
      }
    });
  }

  /// 战旗升级
  Future warFlag() async {
    var res = await MGUtil.talentPKOper({'type': 25, 'action': 1});
    int warFlagCount = res.total;
    if (warFlagCount != null) {
      Global.userConfig.warFlags.forEach((int key, int val) async {
        if (val != 0 && warFlagCount > 0) {
          var count = min(val, warFlagCount);
          for (var i = 0; i < count; i++) {
            res = await MGUtil.talentPKOper(
                {'type': 25, 'action': 2, 'index': key, 'upgrade': 1});
            if (res.result == 0) {
              warFlagCount--;
            } else {
              showSnackBar('战旗 ${res.resultstr}');
            }
          }
        }
      });
    }
  }

  handleOneKeyPressed() async {
    var res = await MGUtil.talentPKOper({'type': 1});
    if (res.free == 0) {
      // 免费占卜
      await MGUtil.talentPKOper({'augury': 1, 'type': 24});
    }
    if (res.selfAward == 1) {
      // 领取奖励
      var res = await MGUtil.talentPKOper({'type': 11});
      showActivityOperAward(res.award);
    }

    await warFlag();

    // 宝宝列表
    res = await MGUtil.talentPKOper({'type': 3});
    int trainCount = res.tnum;
    await trainPet(trainCount);

    int contactCount = res.contactCount;
    await contractPet(contactCount);

    if (res.qnum > 0 &&
        Global.userConfig.quality != null &&
        Global.userConfig.quality != 0) {
      res = await MGUtil.talentPKOper(
          {'type': 15, 'paytype': 1, 'id': Global.userConfig.quality});
    }
    showSnackBar('一键执行完成');
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
                  child: Text(selectPetPK != null
                      ? '${selectPetPK?.name}(${selectPetPK?.stage})'
                      : '未开始'),
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
                onPressed: advNum > 0 ? adventure : null,
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
                onPressed: challengeNum > 0 ? autoChallenge : null,
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
                      onPressed: challengeNum > 0
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
