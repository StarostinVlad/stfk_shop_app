import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:stfkshopapp/product_status.dart';

import 'ErrorPlaceholder.dart';

class ProductPage extends StatefulWidget {
  final String title, href;

  @override
  _ProductPageState createState() => _ProductPageState();

  ProductPage(this.href, {this.title});
}

class _ProductPageState extends State<ProductPage> {
  Future<List<Warehouse>> _parse({String url}) async {
    print(url);
    final responce = await http.Client().get(Uri.parse(url));
    if (responce.statusCode == 200) {
      return parseList(responce.body);
    } else {
      throw Exception("Failed to load main page!");
    }
  }

  List<Warehouse> parseList(String html) {
    var document = parse(html);
    var elements = document.getElementsByClassName('tr');

    return elements.map((item) {
//      print(item.outerHtml);
      String title = item
          .querySelector('div.td_name div.catalog__stock_tovar_list_name')
          .text
          .trim();
      String subTitle = item
          .querySelector('div.td_name div.catalog__stock_tovar_list_phone')
          .text
          .trim();
      String price = item.querySelector('div.td_cena').text.trim();

      bool inStock = item
          .querySelector('div.td_quantity span')
          .classes
          .contains("in-stock");
      return Warehouse(
          title: title, subTitle: subTitle, inStock: inStock, price: price);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Warehouse>>(
          future: _parse(url: widget.href),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return const CircularProgressIndicator();
            if (snapshot.hasData) {
              return ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Column(children: [
                        Text(
                          '${snapshot.data[index].title} : ${snapshot.data[index].price ?? 'цена отсутствует'}',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          snapshot.data[index].subTitle,
                          style: TextStyle(fontSize: 12),
                        ),
                      ]),
                      subtitle: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: ProductStatus(
                                  inStock: snapshot.data[index].inStock,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  snapshot.data[index].price,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: MaterialButton(
                                    color: Theme.of(context).accentColor,
                                    child: Text(snapshot.data[index].inStock
                                        ? 'В корзину'
                                        : 'Заказать'),
                                    onPressed: () {}),
                              ),
                            ),
                          ]),
                    );
                  });
            } else if (snapshot.hasError) {
              return ErrorPlaceholder(
                textMessage: snapshot.error.toString(),
                onPressed: () {
                  setState(() {});
                },
              );
            }
            return const CircularProgressIndicator();
          }),
    );
  }
}

class Warehouse {
  String title;
  String subTitle;
  bool inStock;
  String price;

  Warehouse({this.title, this.subTitle, this.inStock, this.price});
}
