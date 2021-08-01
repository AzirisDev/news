import 'package:news/model/article_response.dart';
import 'package:news/repository/respository.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc{
  final NewsRepository newsRepository = NewsRepository();
  final BehaviorSubject<ArticleResponse> _subject =
  BehaviorSubject<ArticleResponse>();

  search(String searchValue) async {
    ArticleResponse response = await newsRepository.search(searchValue);
    _subject.sink.add(response);
  }

  dispose(){
    _subject.close();
  }

  BehaviorSubject<ArticleResponse> get subject => _subject;
}

final searchBloc = SearchBloc();