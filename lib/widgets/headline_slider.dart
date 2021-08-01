import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/bloc/get_top_headlines_bloc.dart';
import 'package:news/elements/error_element.dart';
import 'package:news/elements/loader_element.dart';
import 'package:news/model/article.dart';
import 'package:news/model/article_response.dart';
import 'package:news/screens/tabs/news_detail.dart';
import 'package:timeago/timeago.dart' as timeago;

class HeadlineSliderWidget extends StatefulWidget {
  const HeadlineSliderWidget({Key key}) : super(key: key);

  @override
  _HeadlineSliderWidgetState createState() => _HeadlineSliderWidgetState();
}

class _HeadlineSliderWidgetState extends State<HeadlineSliderWidget> {
  @override
  void initState() {
    super.initState();
    getTopHeadlinesBloc.getHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream: getTopHeadlinesBloc.subject.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.isNotEmpty) {
            return buildErrorWidget(snapshot.data.error);
          }
          return _buildHeadlineSlider(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.data.error);
        } else {
          return buildLoaderWidget();
        }
      },
    );
  }

  Widget _buildHeadlineSlider(ArticleResponse data) {
    List<ArticleModel> articles = data.articles;
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          enlargeCenterPage: true,
          height: 200,
          viewportFraction: 0.7,
        ),
        items: getExpensesSliders(articles),
      ),
    );
  }

  getExpensesSliders(List<ArticleModel> articles) {
    return articles.map(
      (article) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetail(
                  articleModel: article,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: article.img == null
                          ? const AssetImage('assets/img/placeholder.jpg')
                          : NetworkImage(article.img),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [
                        0.1,
                        0.9,
                      ],
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: 250,
                    child: Column(
                      children: [
                        Text(
                          article.title,
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(
                    article.source.name,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 9.0,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Text(
                    timeUntil(
                      DateTime.parse(
                        article.date,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 9.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).toList();
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
