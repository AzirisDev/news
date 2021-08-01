import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:news/bloc/bottom_nav_bar_bloc.dart';
import 'package:news/screens/sources_screen.dart';
import 'package:news/screens/home_screen.dart';
import 'package:news/screens/tabs/search_screen.dart';
import 'package:news/style/theme.dart' as Style;

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  BottomNavBarBloc _bottomNavBarBloc;

  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Style.Colors.mainColor,
          title: const Text(
            'NewsApp',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<NavBarItem>(
          stream: _bottomNavBarBloc.itemStream,
          initialData: _bottomNavBarBloc.defaultItem,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case NavBarItem.HOME:
                return HomeScreen();
              case NavBarItem.SOURCES:
                return SourcesScreen();
              case NavBarItem.SEARCH:
                return SearchScreen();
            }
          },
        ),
      ),
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (context, snapshot) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[100],
                  spreadRadius: 5,
                  blurRadius: 10.0,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                iconSize: 20.0,
                unselectedItemColor: Style.Colors.grey,
                unselectedFontSize: 9.5,
                selectedFontSize: 9.5,
                type: BottomNavigationBarType.fixed,
                fixedColor: Style.Colors.mainColor,
                currentIndex: snapshot.data.index,
                onTap: _bottomNavBarBloc.pickItem,
                items: [
                  BottomNavigationBarItem(
                    label: 'Home',
                    icon: Icon(
                      EvaIcons.homeOutline,
                    ),
                    activeIcon: Icon(
                      EvaIcons.home,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Sources',
                    icon: Icon(
                      EvaIcons.gridOutline,
                    ),
                    activeIcon: Icon(
                      EvaIcons.grid,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Search',
                    icon: Icon(
                      EvaIcons.searchOutline,
                    ),
                    activeIcon: Icon(
                      EvaIcons.search,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
