import 'package:flutter/material.dart';

class CatalogItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final GestureTapCallback onPressed;

  CatalogItem({this.imageUrl, this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        splashColor: Theme.of(context).accentColor.withOpacity(0.3),
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: Align(
              child: Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              alignment: Alignment.center,
            )),
      ),
    );
  }
}

class CatalogGroupItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final GestureTapCallback onPressed;

  CatalogGroupItem({this.imageUrl, this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        splashColor: Theme.of(context).accentColor.withOpacity(0.3),
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: Align(
              child: Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              alignment: Alignment.bottomCenter,
            )),
      ),
    );
  }
}
