import 'package:flutter/material.dart';
import 'package:kou_navigation_project/core/open_url.dart';
import 'package:kou_navigation_project/theme/light_theme.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _lightColor = LightColor();
    final String kouLogoPath = "assets/icons/kou_pin_logo.png";
    final double sizedBoxHeight = 20;
    bool isUrlOpened = true;
    return Drawer(
      backgroundColor: _lightColor.kouGreen,
      width: MediaQuery.of(context).size.width * 0.7,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: _lightColor.kouGreen),
            child: Center(child: Image.asset(kouLogoPath)),
          ),
          Container(
            color: _lightColor.scaffoldBackground,
            height: MediaQuery.of(context).size.width * 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: sizedBoxHeight,
                ),
                ListTile(
                  leading: SizedBox(
                      height: MediaQuery.of(context).size.width / 10,
                      child: Image.asset(
                        "assets/icons/chrome.png",
                      )),
                  title: Text('Web site',
                      style: Theme.of(context).textTheme.subtitle2),
                  onTap: () async {
                    isUrlOpened =
                        await OpenUrl.openMap("https://www.kocaeli.edu.tr/");

                    if (isUrlOpened == false) {
                      showDialogs(context);
                    }
                  },
                ),
                SizedBox(
                  height: sizedBoxHeight,
                ),
                ListTile(
                  leading: SizedBox(
                      height: MediaQuery.of(context).size.width / 10,
                      child: Image.asset("assets/icons/instagram.png")),
                  title: Text("Instagram",
                      style: Theme.of(context).textTheme.subtitle2),
                  onTap: () async {
                    isUrlOpened = await OpenUrl.openMap(
                        "https://www.instagram.com/kou92official/");
                    if (isUrlOpened == false) {
                      showDialogs(context);
                    }
                  },
                ),
                SizedBox(
                  height: sizedBoxHeight,
                ),
                ListTile(
                  leading: SizedBox(
                      height: MediaQuery.of(context).size.width / 10,
                      child: Image.asset("assets/icons/facebook.png")),
                  title: Text("Facebook",
                      style: Theme.of(context).textTheme.subtitle2),
                  onTap: () async {
                    isUrlOpened = await OpenUrl.openMap(
                        "https://www.facebook.com/kou92official/");

                    if (isUrlOpened == false) {
                      showDialogs(context);
                    }
                  },
                ),
                SizedBox(
                  height: sizedBoxHeight,
                ),
                ListTile(
                  leading: SizedBox(
                      height: MediaQuery.of(context).size.width / 10,
                      child: Image.asset("assets/icons/twitter.png")),
                  title: Text("Twitter",
                      style: Theme.of(context).textTheme.subtitle2),
                  onTap: () async {
                    isUrlOpened = await OpenUrl.openMap(
                        "https://twitter.com/kou92official");

                    if (isUrlOpened == false) {
                      showDialogs(context);
                    }
                  },
                ),
                SizedBox(
                  height: sizedBoxHeight,
                ),
                ListTile(
                  leading: SizedBox(
                      height: MediaQuery.of(context).size.width / 10,
                      child: Image.asset("assets/icons/youtube.png")),
                  title: Text("Youtube",
                      style: Theme.of(context).textTheme.subtitle2),
                  onTap: () async {
                    isUrlOpened = await OpenUrl.openMap(
                        "https://www.youtube.com/c/kocaeli%C3%BCniversitesi");

                    if (isUrlOpened == false) {
                      showDialogs(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showDialogs(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 0),
          contentPadding: EdgeInsets.only(top: 10),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          title: Center(child: Text("Bağlantı açılamadı")),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          content: Icon(
            Icons.link_off_outlined,
            size: (MediaQuery.of(context).size.width * 0.1),
          ),
          actions: [
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text("Tamam")))
          ],
        ),
      ),
    );
  }
}
