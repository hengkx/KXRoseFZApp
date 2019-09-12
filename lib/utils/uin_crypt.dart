import 'dart:typed_data';

class UinCrypt {
  static const String hexChars = "0123456789ABCDEF";
  static const String spaceChars = " \t\r\n";
  static const int DELTA = 0x9e3779b9;
  static const int LOG_ROUNDS = 4;
  static const int ROUNDS = 16;
  static const int SALT_LEN = 2;
  static const int ZERO_LEN = 7;

  static Uint8List hexstr2buf(String param1) {
    String loc2;
    int loc4 = 0;
    var loc5 = 0;
    var loc6 = 0;
    var loc7 = 0;
    if (param1 != null && param1.length > 0) {
      loc2 = param1.toUpperCase();
      List<int> buffer = List();
      loc4 = loc2.length;
      loc5 = 0;
      while (loc5 < loc4) {
        loc6 = hexChars.indexOf(loc2[loc5]);
        loc7 = hexChars.indexOf(loc2[loc5 + 1]);
        if (loc6 >= 0 && loc7 >= 0) {
          buffer.add((loc6 << 4) + loc7);
          loc5 = loc5 + 2;
          continue;
        }
        return null;
      }
      return Uint8List.fromList(buffer);
    }
    return null;
  }

  static int getUint32(List<int> param1) {
    var buffer = Uint8List.fromList(param1).buffer;
    var bytes = new ByteData.view(buffer);
    return bytes.getUint32(0, Endian.little);
  }

  static Uint8List intToBytes(int val) {
    var buffer = new Uint8List(4).buffer;
    var bdata = new ByteData.view(buffer);
    bdata.setInt32(0, val);
    return bdata.buffer.asUint8List();
  }

  static Uint8List teaDecryptECB(Uint8List param1, Uint8List param2) {
    int loc3 = getUint32(param1.sublist(0, 4).reversed.toList());
    int loc4 = getUint32(param1.sublist(4, 8).reversed.toList());

    var loc5 = Uint32List(4);
    loc5[0] = getUint32(param2.sublist(0, 4).reversed.toList());
    loc5[1] = getUint32(param2.sublist(4, 8).reversed.toList());
    loc5[2] = getUint32(param2.sublist(8, 12).reversed.toList());
    loc5[3] = getUint32(param2.sublist(12, 16).reversed.toList());

    int loc6 = DELTA << LOG_ROUNDS;
    var loc7 = 0;
    while (loc7 < ROUNDS) {
      var temp1 = ((loc3 << 4) + loc5[2]).toUnsigned(32) ^
          (loc3 + loc6).toUnsigned(32) ^
          (loc3 >> 5).toUnsigned(32) + loc5[3];
      loc4 = BigInt.from(loc4 - temp1).toUnsigned(32).toInt();

      var temp2 = ((loc4 << 4) + loc5[0]).toUnsigned(32) ^
          (loc4 + loc6).toUnsigned(32) ^
          ((loc4 >> 5).toUnsigned(32) + loc5[1]);
      loc3 = BigInt.from(loc3 - temp2).toUnsigned(32).toInt();
      loc6 = loc6 - DELTA;
      loc7++;
    }

    List<int> result = List<int>();

    result.addAll(intToBytes(loc3));
    result.addAll(intToBytes(loc4));
    return Uint8List.fromList(result);
  }

  static int oiSymmetryDecrypt2(
      Uint8List param1, int param2, int param3, Uint8List param4) {
    var loc7 = 0;

    var msp1 = param1.toList();
    var loc8 = param1.sublist(0, 8);
    var loc9 = teaDecryptECB(loc8, param4);
    var loc10 = loc9[0] & 7;

    var loc6 = param3 - 1 - loc10 - SALT_LEN - ZERO_LEN;
    if (loc6 < 0) {
      return 0;
    }
    var loc11 = loc6;
    var loc12 = Uint8List(8);
    loc6 = 0;
    while (loc6 < 8) {
      loc12[loc6] = 0;
      loc6++;
    }
    var loc13 = loc12;
    loc6 = 1;
    var ms9Position = 1 + loc10;
    while (loc6 <= SALT_LEN) {
      if (ms9Position < 8) {
        ms9Position++;
        loc6++;
      } else if (ms9Position == 8) {
        loc13 = loc8;

        loc8 = Uint8List.fromList(msp1.sublist(0, 8));
        loc7 = 0;
        while (loc7 < 8) {
          loc9[loc7] = (loc9[loc7] ^ loc8[loc7]);
          loc7++;
        }
        loc9 = teaDecryptECB(loc9, param4);
        ms9Position = 0;
      }
    }
    List<int> msp5 = List();
    var ms13Position = ms9Position;
    while (loc11 > 0) {
      if (ms9Position < 8) {
        int m9 = loc9[ms9Position];
        ms9Position++;
        int m13 = loc13[ms13Position];
        ms13Position++;
        msp5.add(m9 ^ m13);
        loc11--;
      } else if (ms9Position == 8) {
        loc13 = loc8;

        loc8 = Uint8List.fromList(msp1.sublist(8, 16));
        loc7 = 0;
        while (loc7 < 8) {
          loc9[loc7] = (loc9[loc7] ^ loc8[loc7]);
          loc7++;
        }
        loc9 = teaDecryptECB(loc9, param4);
        ms9Position = 0;
        ms13Position = 0;
      }
    }
    loc6 = 1;

    while (loc6 <= ZERO_LEN) {
      if (ms9Position < 8) {
        loc6++;
      } else if (ms9Position == 8) {
        loc13 = loc8;
        loc8 = Uint8List(8);
        loc7 = 0;
        while (loc7 < 8) {
          loc9[loc7] = (loc9[loc7] ^ loc8[loc7]);
          loc7++;
        }
        loc9 = teaDecryptECB(loc9, param4);
        ms9Position = 0;
        ms13Position = 0;
      }
    }
    return getUint32(msp5.reversed.toList());
  }

  /// 解密QQ号
  static int decryptUin(String str) {
    Uint8List bytes = Uint8List.fromList('rose1314minigame'.codeUnits);
    var buf = hexstr2buf(str);
    return oiSymmetryDecrypt2(buf, 0, buf.length, bytes);
  }
}
