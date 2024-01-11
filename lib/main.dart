import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brewappsmovie/pages/Nowplaying.dart';
import 'package:brewappsmovie/pages/Toprated.dart';
import 'package:brewappsmovie/themes/themestyle.dart';
void main() async {
  return runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => new ThemeNotifier(),
    child: MyApp(),
  ));
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
          theme: theme.getTheme(),
        debugShowCheckedModeBanner: false,
        home: new HomePage()
    ));
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final TextStyle unselectedLabelStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontWeight: FontWeight.w500,
      fontSize: 12);
  final TextStyle selectedLabelStyle =
  TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12);
  buildBottomNavigationMenu(context, landingPageController) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SizedBox(
          height: 54,
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            showSelectedLabels: true,
            onTap: landingPageController.changeTabIndex,
            currentIndex: landingPageController.tabIndex.value,
            backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
            unselectedItemColor: Colors.white.withOpacity(0.5),
            selectedItemColor: Colors.white,
            unselectedLabelStyle: unselectedLabelStyle,
            selectedLabelStyle: selectedLabelStyle,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(bottom: 7),
                  child: Icon(
                    Icons.home,
                    size: 20.0,
                  ),
                ),
                label: 'Now Playing',
                backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(bottom: 7),
                  child: Icon(
                    Icons.search,
                    size: 20.0,
                  ),
                ),
                label: 'Top Rated',
                backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
              ),

            ],
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    final LandingPageController landingPageController =
    Get.put(LandingPageController(), permanent: false);
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => MaterialApp(
          theme: theme.getTheme(),
          debugShowCheckedModeBanner: false,
    home: SafeArea(
        child: Scaffold(

          appBar: AppBar(

            title: Text("BREWAPPS MOVIE FLIX", style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
            actions: [
              IconButton(
                icon: const Icon(Icons.dark_mode),
                onPressed: () {
                  theme.setDarkMode();
                },
              ),
              IconButton(
                icon: const Icon(Icons.light_mode),
                onPressed: () {
                  theme.setLightMode();
                },
              ),
            ],
            backgroundColor: Colors.white,
          ),
          bottomNavigationBar:
          buildBottomNavigationMenu(context, landingPageController),
          body: Obx(() => IndexedStack(
            index: landingPageController.tabIndex.value,
            children: [
              NowPlaying(),
              Toprated()

            ],
          )),
        ))));
  }
}
class LandingPageController extends GetxController {
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

