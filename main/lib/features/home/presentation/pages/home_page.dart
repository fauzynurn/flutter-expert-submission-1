import 'package:ditonton/features/about/presentation/about_page.dart';
import 'package:movie/presentation/pages/movie_page.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:tv_series/presentation/pages/tv_series_page.dart';
import 'package:watch_list/presentation/pages/watch_list_page.dart';

import '../../features/home_movie/presentation/app_home_movie_page.dart';
import '../../features/home_tv_series/presentation/app_home_tv_series_page.dart';
import 'app_watch_list_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentSubRoute = HomeMoviePage.routeName;

  void redirectPage(
    String route, {
    required BuildContext context,
  }) {
    if (route != currentSubRoute) {
      setState(
        () {
          currentSubRoute = route;
        },
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: const Key(
      //   movieListScaffoldKey,
      // ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                redirectPage(
                  HomeMoviePage.routeName,
                  context: context,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('TV Series'),
              onTap: () {
                redirectPage(
                  HomeTvSeriesPage.routeName,
                  context: context,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                redirectPage(
                  WatchListPage.routeName,
                  context: context,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About'),
              onTap: () {
                redirectPage(
                  AboutPage.routeName,
                  context: context,
                );
              },
            ),
          ],
        ),
      ),
      body: body(),
    );
  }

  void openDrawer(BuildContext parentContext) {
    Scaffold.of(parentContext).openDrawer();
  }

  Widget body() {
    switch (currentSubRoute) {
      case HomeMoviePage.routeName:
        return Builder(
          builder: (context) => AppHomeMoviePage(
            onTapHamburgerButton: () {
              openDrawer(context);
            },
          ),
        );
      case HomeTvSeriesPage.routeName:
        return Builder(
          builder: (context) => AppHomeTvSeriesPage(
            onTapHamburgerButton: () {
              openDrawer(context);
            },
          ),
        );
      case WatchListPage.routeName:
        return Builder(builder: (context) {
          return AppWatchListPage(
            onTapHamburgerButton: () {
              openDrawer(context);
            },
          );
        });
      case AboutPage.routeName:
        return Builder(builder: (context) {
          return AboutPage(
            onTapHamburgerButton: () {
              openDrawer(context);
            },
          );
        });
      default:
        return SizedBox.shrink();
    }
  }

  Widget searchButton() {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, SearchPage.routeName);
      },
      icon: Icon(Icons.search),
    );
  }
}
