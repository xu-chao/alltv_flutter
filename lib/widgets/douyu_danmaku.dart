// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';

// class LiveDanmakuPage extends StatefulWidget {
//   final int roomId;
//   LiveDanmakuPage(this.roomId);
//   @override
//   _LiveDanmakuPageState createState() => _LiveDanmakuPageState();
// }

// class _LiveDanmakuPageState extends State<LiveDanmakuPage>
//     with AutomaticKeepAliveClientMixin<LiveDanmakuPage> {
//   Timer timer;
//   IOWebSocketChannel _channel;
//   int totleTime = 0;
//   List _messageList = [];
//   @override
//   void initState() {
//     timer = Timer.periodic(Duration(seconds: 70), (callback) {
//       totleTime += 70;
//       //sendXinTiaoBao();
//       print("时间: $totleTime s");
//       _channel.sink?.close();
//       initLive();
//     });
//     initLive();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     _channel?.sink?.close();
//     super.dispose();
//   }

//   @override
//   bool get wantKeepAlive => true;

//   //初始化
//   void initLive() {
//     _channel = IOWebSocketChannel.connect(
//         "wss://danmuproxy.douyu.com:8501");
//     joinRoom(widget.roomId);
//     setListener();
//   }

//   void sendXinTiaoBao() {
//     List<int> code = [0, 0, 0, 16, 0, 16, 0, 1, 0, 0, 0, 2, 0, 0, 0, 1];
//     _channel.sink.add(Uint8List.fromList(code).buffer);
//   }

//   //加入房间
//   void joinRoom(int id) {
//     var login = "type@=loginreq/roomid@={$id}/\x00";
//     List<int> msg= utf8.encode(login);
//     int code =689;
//     var message_length=msg.length+8;

//     // _channel.sink.add();
//   }

//   //设置监听
//   void setListener() {
//     _channel.stream.listen((msg) {
//       Uint8List list = Uint8List.fromList(msg);
//       decode(list);
//     });
//   }

//   //对消息编码
//   Uint8List encode(int op, {String msg}) {

//   }

//   //对消息进行解码
//   decode(Uint8List list) {
//     int packLen = readInt(list, 0, 4);
//     int headerLen = readInt(list, 4, 2);
//     int op = readInt(list, 8, 4);
//     // print("接收到：");
//     // print("listLen ${list.length}");
//     // print("packLen $packLen");
//     // print("headerLen $headerLen");
//     // print("op $op");
//     switch (op) {
//       case 8:
//         print("进入房间");
//         break;
//       case 5:
//         int offset = 0;
//         while (offset < list.length) {
//           packLen = readInt(list, offset + 0, 4);
//           headerLen = 16;
//           Uint8List body = list.sublist(offset + headerLen, offset + packLen);
//           String data = utf8.decode(body);
//           offset += packLen;
//           //print(data);
//           Map<String, dynamic> jd = json.decode(data);
//           switch (jd["cmd"]) {
//             case "DANMU_MSG":
//               String msg = jd["info"][1].toString();
//               String name = jd["info"][2][1].toString();
//               // print("$name 说： $msg");
//               addDanmaku(LiveDanmakuItem(name, msg));
//               break;
//             // case "SEND_GIFT":
//             //   String name = jd["data"]["uname"].toString();
//             //   String action = jd["data"]["action"].toString();
//             //   String msg = jd["data"]["giftName"].toString();
//             //   int count = jd["data"]["num"];
//             //   print("$name $action $count 个 $msg");
//             //   addGift(GiftItem(name, action, count, msg));
//             //   break;
//             default:
//           }
//         }
//         break;
//       case 3:
//         int people = readInt(list, headerLen, 4);
//         print("人气: $people");
//         break;
//       default:
//     }
//   }

//   //写入编码
//   Uint8List writeInt(Uint8List src, int start, int len, int value) {
//     int i = 0;
//     while (i < len) {
//       src[start + i] = value ~/ pow(256, len - i - 1);
//       i++;
//     }
//     return src;
//   }

//   //从编码读出数字
//   int readInt(Uint8List src, int start, int len) {
//     int res = 0;
//     for (int i = len - 1; i >= 0; i--) {
//       res += pow(256, len - i - 1) * src[start + i];
//     }
//     return res;
//   }

//   void addDanmaku(LiveDanmakuItem item) {
//     setState(() {
//       _messageList.insert(0, item);
//     });
//   }

//   void addGift(GiftItem item) {
//     setState(() {
//       _messageList.add(item);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return ListView.builder(
//         itemCount: _messageList.length,
//         padding: const EdgeInsets.only(left: 5, top: 2, right: 5),
//         reverse: true,
//         shrinkWrap: true,
//         itemBuilder: (context, i) {
//           Widget item;
//           if (_messageList[i] is LiveDanmakuItem) {
//             LiveDanmakuItem liveDanmakuItem = _messageList[i];
//             item = Container(
//               padding: EdgeInsets.all(5),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     " ${liveDanmakuItem.name} : ",
//                     style: TextStyle(fontWeight: FontWeight.w700),
//                   ),
//                   Expanded(
//                     child: Text(
//                       "${liveDanmakuItem.msg}",
//                     ),
//                   )
//                 ],
//               ),
//             );
//           }
//           return item;
//         });
//   }
// }

// class DanmakuPackage {
//   int op;
//   dynamic body;
// }

// class LiveDanmakuItem {
//   String name;
//   String msg;
//   LiveDanmakuItem(this.name, this.msg);
// }