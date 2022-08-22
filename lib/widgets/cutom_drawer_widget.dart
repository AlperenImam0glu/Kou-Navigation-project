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
                ListTile(
                  leading: SizedBox(
                      height: MediaQuery.of(context).size.width / 10,
                      child: Image.asset(
                        "assets/icons/chrome.png",
                      )),
                  title: Text('Web site',
                      style: Theme.of(context).textTheme.subtitle2),
                  onTap: () {
                    OpenUrl.openMap("https://www.kocaeli.edu.tr/");
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
                  onTap: () {
                    OpenUrl.openMap("https://www.instagram.com/kou92official/");
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
                  onTap: () {
                    OpenUrl.openMap("https://www.facebook.com/kou92official/");
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
                  onTap: () {
                    OpenUrl.openMap("https://twitter.com/kou92official");
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
                  onTap: () {
                    OpenUrl.openMap(
                        "https://www.youtube.com/c/kocaeli%C3%BCniversitesi");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
