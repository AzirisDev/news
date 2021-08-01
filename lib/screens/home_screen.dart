import 'package:flutter/material.dart';
import 'package:news/widgets/headline_slider.dart';
import 'package:news/widgets/hot_news.dart';
import 'package:news/widgets/top_channels.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        HeadlineSliderWidget(),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Top channels',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TopChannels(),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Hot News',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        HotNews(),
      ],
    );
  }
}
