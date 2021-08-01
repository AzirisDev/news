import 'package:flutter/cupertino.dart';
import 'package:news/model/article_response.dart';
import 'package:news/repository/respository.dart';
import 'package:rxdart/rxdart.dart';

class GetSourceNewsBloc {
  final NewsRepository newsRepository = NewsRepository();
  final BehaviorSubject<ArticleResponse> _subject =
      BehaviorSubject<ArticleResponse>();

  getSourceNews(String sourceId) async {
    ArticleResponse response = await newsRepository.getSourceNews(sourceId);
    _subject.sink.add(response);
  }

  void drainStream() {subject.value = null;}
  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<ArticleResponse> get subject => _subject;
}

final getSourceNewsBloc = GetSourceNewsBloc();
