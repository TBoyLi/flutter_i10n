import 'package:flutter/material.dart';
import 'package:i10n_app/config/storage_manager.dart';
import 'package:i10n_app/generated/l10n.dart';

class LocaleModel extends ChangeNotifier {

  ///配置语言语种
  static const localeValueList = ['', 'zh-CN', 'en'];

  ///本地语言选择的 key值
  static const keyLocaleIndex = 'keyLocaleIndex';

  int _localeIndex;

  int get localeIndex => _localeIndex;

  Locale get locale {
    if (_localeIndex > 0) {
      var value = localeValueList[_localeIndex].split("-");
      return Locale(value[0], value.length == 2 ? value[1] : '');
    }
    // 跟随系统
    return null;
  }

  LocaleModel() {
    _localeIndex = StorageManager.sharedPreferences.getInt(keyLocaleIndex) ?? 0;
  }

  switchLocale(int index) {
    _localeIndex = index;
    notifyListeners();
    StorageManager.sharedPreferences.setInt(keyLocaleIndex, index);
  }

  static String localeName(index, context) {
    switch (index) {
      case 0:
        return S.of(context).autoBySystem;
      case 1:
        return '中文';
      case 2:
        return 'English';
      default:
        return '';
    }
  }
}
