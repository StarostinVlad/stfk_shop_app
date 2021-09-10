import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stfkshopapp/GroupPage.dart';
import 'package:stfkshopapp/GroupsPage.dart';
import 'package:stfkshopapp/MyHomePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Than we setup preferred orientations,
  // and only after it finished we run our app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: (settings) {
        var url = Uri.parse(settings.name);

        print(url.path);
        var path = url.path.split('/');
        print(path);

        return MaterialPageRoute(builder: (context) {
          if (path[1] == 'katalog' && path.length <= 2)
            return GroupsPage(
              title: 'Каталог',
              url: settings.arguments,
            );
          if (path[1] == 'katalog' ||
              path[1] == 'catalog' && path[2].isNotEmpty)
            return GroupPage(
              title: 'Группа',
              url: settings.arguments,
            );
          return MyHomePage(
            title: 'Главная',
          );
        });
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,

        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
