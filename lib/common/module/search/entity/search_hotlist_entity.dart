class SearchHotListEntity {
  SearchHotListEntity({
    List<HotWords>? hotWords,
  }) {
    _hotWords = hotWords;
  }

  SearchHotListEntity.fromJson(dynamic json) {
    if (json['hot_words'] != null) {
      _hotWords = [];
      json['hot_words'].forEach((v) {
        _hotWords?.add(HotWords.fromJson(v));
      });
    }
  }

  List<HotWords>? _hotWords;

  SearchHotListEntity copyWith({
    List<HotWords>? hotWords,
  }) =>
      SearchHotListEntity(
        hotWords: hotWords ?? _hotWords,
      );

  List<HotWords>? get hotWords => _hotWords;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_hotWords != null) {
      map['hot_words'] = _hotWords?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "q"
/// name : "热门搜索"
/// type : "radio"
/// submenu : [{"code":"高薪","name":"高薪"},{"code":"兼职","name":"兼职"},{"code":"管住","name":"管住"},{"code":"管吃","name":"管吃"},{"code":"美团","name":"美团"}]

class HotWords {
  HotWords({
    String? id,
    String? name,
    String? type,
    List<Submenu>? submenu,
  }) {
    _id = id;
    _name = name;
    _type = type;
    _submenu = submenu;
  }

  HotWords.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _type = json['type'];
    if (json['submenu'] != null) {
      _submenu = [];
      json['submenu'].forEach((v) {
        _submenu?.add(Submenu.fromJson(v));
      });
    }
  }

  String? _id;
  String? _name;
  String? _type;
  List<Submenu>? _submenu;

  HotWords copyWith({
    String? id,
    String? name,
    String? type,
    List<Submenu>? submenu,
  }) =>
      HotWords(
        id: id ?? _id,
        name: name ?? _name,
        type: type ?? _type,
        submenu: submenu ?? _submenu,
      );

  String? get id => _id;

  String? get name => _name;

  String? get type => _type;

  List<Submenu>? get submenu => _submenu;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['type'] = _type;
    if (_submenu != null) {
      map['submenu'] = _submenu?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// code : "高薪"
/// name : "高薪"

class Submenu {
  Submenu({
    String? code,
    String? name,
  }) {
    _code = code;
    _name = name;
  }

  Submenu.fromJson(dynamic json) {
    _code = json['code'];
    _name = json['name'];
  }

  String? _code;
  String? _name;

  Submenu copyWith({
    String? code,
    String? name,
  }) =>
      Submenu(
        code: code ?? _code,
        name: name ?? _name,
      );

  String? get code => _code;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['name'] = _name;
    return map;
  }
}
