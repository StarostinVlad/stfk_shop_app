import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:stfkshopapp/ProductPage.dart';
import 'package:stfkshopapp/product_status.dart';

import 'ErrorPlaceholder.dart';
import 'models/Data.dart';

class GroupPage extends StatefulWidget {
  final String title, url;

  const GroupPage({Key key, this.title, this.url}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  Future<CurPage> _data;

  @override
  void initState() {
    super.initState();
    _data = _parse(widget.url);
  }

  Future<CurPage> _parse(String url) async {
    print(url);
    final responce = await http.Client().post(
        Uri.parse(url.contains(Data.DOMAIN) ? url : Data.DOMAIN + url),
        headers: {'instock': '', 'isAjax': '1'});
    if (responce.statusCode == 200) {
      return parseList(responce.body);
    } else {
      throw Exception("Failed to load main page!");
    }
  }

  CurPage parseList(String html) {
    var document = parse(html);
    var elements =
        document.querySelectorAll('div.tovarlist > table > tbody > tr');
    var pages = document.querySelectorAll("div > section > ul > li > a");

    List<Page> _pages = [];
    for (var page in pages) {
      var href = page.attributes['href'];
      var title = page.text;
      print(href);

      _pages.add(Page(href: href, title: title));
    }

    List<Product> products = elements.map((item) {
      String title = item.getElementsByClassName('name').first.text.trim();

      bool inStock = item
          .getElementsByClassName('in-stock-status')
          .first
          .classes
          .contains("in-stock");

      var a = item.querySelector('div.name > a');
      String href = Data.DOMAIN + a.attributes['href'];

      String image = item.getElementsByClassName('cod').first.text.trim();
      return Product(title: title, code: image, href: href, inStock: inStock);
    }).toList();
    return CurPage(products: products, pages: _pages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<CurPage>(
            future: _data,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done)
                return const CircularProgressIndicator();
              if (snapshot.hasData) {
                return ListView(children: [
                  snapshot.data.pages.isNotEmpty
                      ? SizedBox(
                          height: 50,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.pages.length,
                              itemBuilder: (context, page) {
                                return Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: MaterialButton(
                                      color: Theme.of(context).accentColor,
                                      onPressed: () {
                                        setState(() {
                                          _data = _parse(
                                              snapshot.data.pages[page].href);
                                        });
                                      },
                                      child: Text(
                                          snapshot.data.pages[page].title)),
                                );
                              }),
                        )
                      : SizedBox(),
                  ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                    ),
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.products.length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        title: ListTile(
                            title: Text(
                              snapshot.data.products[index].title,
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              snapshot.data.products[index].code,
                              style: TextStyle(fontSize: 14),
                            ),
                            trailing: ProductStatus(
                              inStock: snapshot.data.products[index].inStock,
                            )),
                        children: [
                          ProductPage(snapshot.data.products[index].href)
                        ],
                      );
                    },
                  ),
                ]);
              } else if (snapshot.hasError) {
                return ErrorPlaceholder(
                  textMessage: snapshot.error.toString(),
                  onPressed: () {
                    setState(() {
                      _data = _parse(widget.url);
                    });
                  },
                );
              }
              return const CircularProgressIndicator();
            }),
      ),
    );
  }
}

class CurPage {
  List<Product> products;
  List<Page> pages;

  CurPage({this.products, this.pages});
}

class Page {
  String href;
  String title;

  Page({this.href, this.title});
}

class Product {
  String title;
  String code;
  String href;
  bool inStock;

  Product({this.title, this.code, this.href, this.inStock});
}
