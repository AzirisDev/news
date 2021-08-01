import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:news/bloc/search_bloc.dart';
import 'package:news/elements/error_element.dart';
import 'package:news/elements/loader_element.dart';
import 'package:news/model/article.dart';
import 'package:news/model/article_response.dart';
import 'package:news/style/theme.dart' as Style;
import 'package:timeago/timeago.dart' as timeago;

import 'news_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchBloc.search('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            controller: _searchController,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            onChanged: (changed) {
              searchBloc.search(_searchController.text);
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: Colors.grey[100],
              suffixIcon: _searchController.text.length > 0
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _searchController.clear();
                          searchBloc.search(_searchController.text);
                        });
                      },
                      icon: Icon(
                        EvaIcons.backspaceOutline,
                        color: Style.Colors.grey,
                      ),
                    )
                  : Icon(
                      EvaIcons.searchOutline,
                      color: Colors.grey,
                      size: 16,
                    ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[100].withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(
                  30,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[100].withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(
                  30,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              hintText: 'Search...',
              hintStyle: TextStyle(
                fontSize: 14,
                color: Style.Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              labelStyle: TextStyle(
                fontSize: 14,
                color: Style.Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            autocorrect: false,
          ),
        ),
        Expanded(
          child: StreamBuilder<ArticleResponse>(
            stream: searchBloc.subject.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null && snapshot.data.error.isNotEmpty) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "No articles",
                          style: TextStyle(color: Colors.black45),
                        ),
                      ],
                    ),
                  );
                }
                return _buildSearchArticles(snapshot.data);
              } else if (snapshot.hasError) {
                return buildErrorWidget(snapshot.data.error);
              } else {
                return buildLoaderWidget();
              }
            },
          ),
        )
      ],
    );
  }

  Widget _buildSearchArticles(ArticleResponse data) {
    List<ArticleModel> articles = data.articles;

    if (articles.isEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "No articles",
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetail(
                    articleModel: articles[index],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[200],
                    width: 1,
                  ),
                ),
              ),
              height: 150,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 3 / 5,
                    child: Column(
                      children: [
                        Text(
                          articles[index].title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              children: [
                                Text(
                                  timeUntil(
                                    DateTime.parse(
                                      articles[index].date,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black26,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      right: 10,
                    ),
                    width: MediaQuery.of(context).size.width * 2 / 5,
                    height: 130,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/img/placeholder.jpg',
                      image: articles[index].img,
                      fit: BoxFit.cover,
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height * 1 / 3,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
