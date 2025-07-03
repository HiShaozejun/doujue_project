extension FunctionExtensions<T> on T {
  void run(Function(T self) block) {
    block(this);
  }

  //语法糖
  R let<R>(R Function(T self) block) {
    return block(this);
  }

  T also(Function(T self) block) {
    block(this);
    return this;
  }
}

extension FunctionExtension on Function? {
  void checkNullInvoke() => this?.run((self) => self());
}

typedef CreateJson<T> = T Function(Map<String, dynamic> json);
