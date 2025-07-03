import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<dynamic> emojiData = [];

class Emoji {
  String? name;
  String? path;

  Emoji({this.name, this.path});
}

class EmojiUtil {
  final Map<String, String> _emojiMap = new Map<String, String>();

  Map<String, String> get emojiMap => _emojiMap;

  static EmojiUtil? _instance;

  static EmojiUtil get instance {
    if (_instance == null) _instance = new EmojiUtil._();
    return _instance!;
  }

  EmojiUtil._() {
    if (emojiData.length > 0) {
      for (var item in emojiData) {
        _emojiMap["[${item['name']}]"] = item['path'];
      }
    }
  }

  static Widget emoJiList(context,
          {Function(String expressionName, String path)? onTap}) =>
      FutureBuilder(
          future: DefaultAssetBundle.of(context)
              .loadString("assets/data/emoji_list.json"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              emojiData = json.decode(snapshot.data.toString());
              return Container(
                height: 150.h,
                padding: EdgeInsets.all(5),
                child: GridView.custom(
                  padding: EdgeInsets.all(3),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 0.5,
                    crossAxisSpacing: 6.0,
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return GestureDetector(
                        onTap: () => onTap?.call(
                            emojiData[index]['name'], emojiData[index]['path']),
                        child: Center(
                          child: Image.asset(
                            emojiData[index]["path"],
                            width: 35,
                            height: 35,
                          ),
                        ),
                      );
                    },
                    childCount: emojiData.length,
                  ),
                ),
              );
            }
            return CircularProgressIndicator();
          });
}
