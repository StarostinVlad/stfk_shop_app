import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'CatalogItem.dart';
import 'ErrorPlaceholder.dart';
import 'models/Data.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({Key key, this.title, this.url}) : super(key: key);
  final String title;
  final String url;

  @override
  State<StatefulWidget> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  Future<List<Data>> _parse() async {
    final responce = await http.Client().get(Uri.parse(widget.url));
    if (responce.statusCode == 200) {
      var document = parse(responce.body);
      var elements = document.getElementsByClassName('catalog_grnomenk-item');

      return elements.map((item) {
        String title = item
            .getElementsByClassName('catalog_grnomenk-text')
            .first
            .text
            .trim();

        String href = Data.DOMAIN + item.attributes['href'];

        String image = item
            .getElementsByClassName('catalog_grnomenk-img')
            .first
            .attributes['style'];

        image = image.substring(image.indexOf('url(') + 4, image.indexOf(')'));

        image = Data.DOMAIN + image;
        print(image);
        return new Data(title: title, image: image, href: href);
      }).toList();
    } else {
      throw Exception("Failed to load main page!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder<List<Data>>(
              future: _parse(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CatalogGroupItem(
                              imageUrl: snapshot.data[index].image,
                              title: snapshot.data[index].title,
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  snapshot.data[index].href,
                                  arguments: snapshot.data[index].href,
                                );
                              });
//                          return Text('${snapshot.data[index].title}');
                        });
                  } else if (snapshot.hasError) {
                    return ErrorPlaceholder(
                      textMessage: snapshot.error.toString(),
                      onPressed: () {
                        setState(() {});
                      },
                    );
                  }
                }
                return const CircularProgressIndicator();
              })),
    );
  }
}
