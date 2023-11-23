import 'dart:async';

import 'package:flutter/material.dart';

// ================================================
// 검색 시 사용자 입력을 기다린 후 실행 할 수 있도록 하는 클래스
// ================================================
class Debounce {
  final int milliseconds;

  Debounce({this.milliseconds = 500});

  Timer? _timer;

  void run(VoidCallback action) {
    if (_timer != null) {
      // 이미 만들어진 경우
      _timer!.cancel(); // 타이머 초기화
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
