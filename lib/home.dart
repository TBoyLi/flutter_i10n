import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:i10n_app/generated/l10n.dart';
import 'package:i10n_app/provider/locale_model.dart';
import 'package:i10n_app/provider/theme_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appName),
        centerTitle: false
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              DarkThemeWidget(),
              SizedBox(height: 20),
              ColorThemeWidget(),
              SizedBox(height: 20),
              LanguageWidget(),
              SizedBox(height: 20),
              FontWidget()
            ],
          ),
        ),
      ),
    );
  }
}

class DarkThemeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
          Theme.of(context).brightness == Brightness.light
              ? Icons.brightness_5
              : Icons.brightness_2,
          color: Theme.of(context).accentColor),
      title: Text(S.of(context).darkMode),
      trailing: CupertinoSwitch(
        activeColor: Theme.of(context).accentColor,
        value: Theme.of(context).brightness == Brightness.dark,
        onChanged: (value) {
          switchDarkMode(context);
        },
      ),
    );
  }

  ///切换黑夜模式
  void switchDarkMode(BuildContext context) {
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      showToast("检测到系统为暗黑模式,已为你自动切换", position: ToastPosition.bottom);
    } else {
      Provider.of<ThemeModel>(context, listen: false).switchTheme(
          userDarkMode: Theme.of(context).brightness == Brightness.light);
    }
  }
}

class ColorThemeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(S.of(context).theme),
      leading: Icon(
        Icons.color_lens,
        color: Theme.of(context).accentColor,
      ),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: <Widget>[
              ...Colors.primaries.map((color) {
                return Material(
                  color: color,
                  child: InkWell(
                    onTap: () => Provider.of<ThemeModel>(context, listen: false)
                        .switchTheme(color: color),
                    child: Container(
                      height: 40,
                      width: 40,
                    ),
                  ),
                );
              }).toList(),
              Material(
                child: InkWell(
                  onTap: () => Provider.of<ThemeModel>(context, listen: false)
                      .switchRandomTheme(
                          brightness: Theme.of(context).brightness),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).accentColor),
                    ),
                    width: 40,
                    height: 40,
                    child: Text(
                      "?",
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).accentColor),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class LanguageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            S.of(context).settingLanguage,
            style: TextStyle(),
          ),
          Text(
            LocaleModel.localeName(
                Provider.of<LocaleModel>(context).localeIndex, context),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
      leading: Icon(
        Icons.public,
        color: Theme.of(context).accentColor,
      ),
      children: <Widget>[
        ListView.builder(
            shrinkWrap: true,
            itemCount: LocaleModel.localeValueList.length,
            itemBuilder: (context, index) {
              var model = Provider.of<LocaleModel>(context);
              return RadioListTile(
                value: index,
                onChanged: (index) {
                  model.switchLocale(index);
                },
                groupValue: model.localeIndex,
                title: Text(LocaleModel.localeName(index, context)),
              );
            })
      ],
    );
  }
}

class FontWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(S.of(context).settingFont),
          Text(
            ThemeModel.fontName(
                Provider.of<ThemeModel>(context).fontIndex, context),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
      leading: Icon(
        Icons.font_download,
        color: Theme.of(context).accentColor,
      ),
      children: <Widget>[
        ListView.builder(
            shrinkWrap: true,
            itemCount: ThemeModel.fontValueList.length,
            itemBuilder: (context, index) {
              var model = Provider.of<ThemeModel>(context);
              return RadioListTile(
                value: index,
                onChanged: (index) {
                  model.switchFont(index);
                },
                groupValue: model.fontIndex,
                title: Text(ThemeModel.fontName(index, context)),
              );
            })
      ],
    );
  }
}
