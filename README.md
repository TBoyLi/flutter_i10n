## 预备知识点

[全局状态管理 - Provider](https://github.com/rrousselGit/provider)

[持久层 - NSUserDefaults（在iOS上）和SharedPreferences（在Android上）](https://pub.dev/packages/shared_preferences)

[Flutter实战 第十三章：国际化](https://book.flutterchina.club/chapter13/)

## 要点

**黑夜模式、色彩主题、字体切换可以通过代码简单看出其逻辑和如何实现的**

**在Flutter实战 第十三章：国际化中已经介绍了如何去实现本地Localizations类、使用intl包、通过intl_translation命令（*命令自行查阅*）生成arb文件（*给翻译人员翻译的文件*）等。在编写代码过程中发现每更改一下arb文件就需要各种命令来生成和修改对应的dart文件，十分的繁琐，那有没有比较舒服一点的操作呢，这里当然是有的啦！**

**步骤如下**

新建之后直接在项目的包依赖文件（pubspec.yaml）中添加如下依赖：(注意依赖层级问题 可参考[源码文件](https://github.com/TBoyLi/flutter_i10n/blob/master/pubspec.yaml) )
```
dependencies:
  ...省略不需要的内容
  #国际化配置 1
  flutter_localizations:
    sdk: flutter

#国际化配置 2
flutter_intl:
  enabled: true
```
执行 flutter packages get 命令之后观察项目lib目录下会生成generated和l10n两个目录

![](https://github.com/TBoyLi/flutter_i10n/blob/master/gif/i10l.png)

这样后期只需维护arb文件即可
1. 修改arb文件内容
```
//intl_en.arb文件添加test字段
{
    ...省略不需要内容
    "test":"Test"
}

//I10n.dart文件自动生成对应test字段
String get test {
    return Intl.message(
      'Test',
      name: 'test',
      desc: '',
      args: [],
    );
}

//布局使用test字段
Text(S.of(context).test)

```
**以上操作是在vscode上自动生成的，在android studio上I10n.dart文件不会自动生成test字段，可自己执行intl_translation命令即可生成test字段**
**arb文件出现错误也不会自动生成相应的字段名**

2.增加arb文件
源码中手动增加了一份intl_zh.arb文件(中文)
generated目录下的intl目录也会自动生成对应的dart文件（messages_zh.dart）
generated目录下的intl目录下messages_all.dart也对自动把新增的messages_zh.dart引用添加进去，如下：
```
Map<String, LibraryLoader> _deferredLibraries = {
  'zh': () => new Future.value(null),//新增中文支持
  'en': () => new Future.value(null),
};

MessageLookupByLibrary _findExact(String localeName) {
  switch (localeName) {
    case 'zh'://新增中文支持
      return messages_zh.messages;
    case 'en':
      return messages_en.messages;
    default:
      return null;
  }
}

```
generated目录下的i10n.dart文件也会自动新增对messages_zh.dart的代理，如下：
```
class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  ...省略不需要内容

  List<Locale> get supportedLocales {
    return const <Locale>[ //支持语言的种类
      Locale('zh', ''), Locale('en', ''),
    ];
  }

  ...省略不需要内容
}
```
**以上操作是在vscode上自动生成的，在android studio上可自己执行intl_translation命令操作**
**arb文件出现错误也不会自动生成相应的dart文件**

**当然布局的显示的语种得自己在自己的代码中添加哦，如下**
```
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
```

***最后看一下入口文件(main.dart)源码整个操作就比较清晰一点了***
```
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider.value(value: ThemeModel()),//主题 provider
          ChangeNotifierProvider.value(value: LocaleModel()),//本地语种 provider
        ],
        child: Consumer2<ThemeModel, LocaleModel>(
          builder:
              (BuildContext context, themeModel, localeModel, Widget child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: themeModel.themeData(),
              darkTheme: themeModel.themeData(platformDarkMode: true),
              locale: localeModel.locale,
              localizationsDelegates: [
                S.delegate,//支持语种对应的字段
                GlobalCupertinoLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              supportedLocales: S.delegate.supportedLocales, //支持的语种
              //路由自行配置 flutter自带 或者 fluro
              onGenerateRoute: null,
              home: Home(),
            );
          },
        ),
      ),
    );
  }
}
```

## 源码

[我在这里~ ~ ~](https://github.com/TBoyLi/flutter_i10n)

## 效果图

![Android](https://github.com/TBoyLi/flutter_i10n/blob/master/gif/Android.gif)
![IOS](https://github.com/TBoyLi/flutter_i10n/blob/master/gif/IOS.gif)
