import 'package:dio/dio.dart';
import 'package:news/model/article_response.dart';
import 'package:news/model/source_response.dart';

class NewsRepository{
  static String mainUrl = 'https://newsapi.org/v2/';
  final String apiKey = 'bf02432501074c3f943cd89fbb976a4d';

  final Dio _dio = Dio();

  var getSourceUrl = '$mainUrl/sources';
  var getTopHeadlinesUrl = '$mainUrl/top-headlines';
  var everythingUrl = '$mainUrl/everything';

  Future<SourceResponse> getSources() async {
    var params = {
      'apiKey' : apiKey,
      'language' : 'en',
      'country' : 'us',
    };

    try{
      Response response = await _dio.get(getSourceUrl, queryParameters: params);
      return SourceResponse.fromJson(response.data);
    } catch(e){
      print('Error occured: $e');
      return SourceResponse.withError(e.toString());
    }
  }

  Future<ArticleResponse> getHotNews() async {
    var params = {
      'apiKey' : apiKey,
      'q' : 'apple',
      'sortBy' : 'popularity',
    };

    try{
      Response response = await _dio.get(everythingUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch(e){
      print('Error occured: $e');
      return ArticleResponse.withError(e.toString());
    }
  }

  Future<ArticleResponse> getSourceNews(String sourceId) async {
    var params = {
      'apiKey' : apiKey,
      'sources' : sourceId,
    };

    try{
      Response response = await _dio.get(getTopHeadlinesUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch(e){
      print('Error occured: $e');
      return ArticleResponse.withError(e.toString());
    }
  }

  Future<ArticleResponse> search(String searchValue) async {
    var params = {
      'apiKey' : apiKey,
      'q' : searchValue,
    };

    try{
      Response response = await _dio.get(getTopHeadlinesUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch(e){
      print('Error occured: $e');
      return ArticleResponse.withError(e.toString());
    }
  }

  Future<ArticleResponse> getTopHeadlines() async {
    var params = {
      "apiKey": apiKey,
      "country" : "us"};
    try {
      Response response = await _dio.get(getTopHeadlinesUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ArticleResponse.withError("$error");
    }
  }

}