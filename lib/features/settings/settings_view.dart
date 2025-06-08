import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/my_theme.dart';
import 'package:todo_app/provider/theme_provider.dart';

class SettingsView extends StatefulWidget {
  static const String routeName = "SettingsScreen";

  SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late var themeProvider;

  String? selectedMode;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    selectedMode =
        themeProvider.currentTheme == ThemeMode.light ? 'Light' : 'Dark';
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Language',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: (themeProvider.currentTheme == ThemeMode.light)
                          ? Color(0xff303030)
                          : MyTheme.whiteColor,
                    ),
              )),
          DropdownMenu(
              hintText: 'Select your language',
              textStyle: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: MyTheme.primaryColor, fontSize: 15),
              menuStyle: MenuStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                (themeProvider.currentTheme == ThemeMode.light)
                    ? MyTheme.whiteColor
                    : MyTheme.blackColorDark,
              )),
              width: double.infinity,
              inputDecorationTheme: light(),
              dropdownMenuEntries: ['Arabic', 'English']
                  .map((lang) => DropdownMenuEntry(
                      label: lang,
                      value: lang,
                      labelWidget: Text(
                        lang,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: MyTheme.primaryColor, fontSize: 20),
                      )))
                  .toList()),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Mode',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: (themeProvider.currentTheme == ThemeMode.light)
                          ? Color(0xff303030)
                          : MyTheme.whiteColor,
                    ),
              )),
          DropdownMenu(
              hintText: selectedMode,
              textStyle: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: MyTheme.primaryColor, fontSize: 15),
              menuStyle: MenuStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                (themeProvider.currentTheme == ThemeMode.light)
                    ? MyTheme.whiteColor
                    : MyTheme.blackColorDark,
              )),
              inputDecorationTheme: light(),
              width: double.infinity,
              onSelected: (mode) {
                selectedMode = mode!;
                mode == 'Light'
                    ? themeProvider.changeMode(ThemeMode.light)
                    : (mode == 'Dark')
                        ? themeProvider.changeMode(ThemeMode.dark)
                        : null;
                setState(() {});
              },
              dropdownMenuEntries: ['Light', 'Dark']
                  .map((mode) => DropdownMenuEntry(
                      label: mode,
                      value: mode,
                      labelWidget: Text(
                        mode,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: MyTheme.primaryColor, fontSize: 20),
                      )))
                  .toList())
        ],
      ),
    );
  }

  InputDecorationTheme light() {
    return InputDecorationTheme(
        filled: true,
        fillColor: (themeProvider.currentTheme == ThemeMode.light)
            ? MyTheme.whiteColor
            : MyTheme.blackColorDark,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: MyTheme.primaryColor),
        ),
        suffixIconColor: MyTheme.primaryColor);
  }
}
