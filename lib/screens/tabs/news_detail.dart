import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news/model/article.dart';
import 'package:news/style/theme.dart' as Style;
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class NewsDetail extends StatefulWidget {
  final ArticleModel articleModel;

  const NewsDetail({Key key, this.articleModel}) : super(key: key);

  @override
  _NewsDetailState createState() => _NewsDetailState(articleModel);
}

class _NewsDetailState extends State<NewsDetail> {
  final ArticleModel articleModel;

  _NewsDetailState(this.articleModel);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: () {
          launch(articleModel.url);
        },
        child: Container(
          height: 48,
          width: MediaQuery.of(context).size.width,
          color: Style.Colors.mainColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Read More',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          articleModel.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Style.Colors.mainColor,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/img/placeholder.jpg',
              image: articleModel.img,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  articleModel.date.substring(0, 10),
                  style: TextStyle(
                    color: Style.Colors.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  articleModel.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Html(
                  data: articleModel.content == null ? '' : articleModel.content,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
