import 'package:news/model/source_response.dart';
import 'package:news/repository/respository.dart';
import 'package:rxdart/rxdart.dart';

class GetSourcesBloc{
  final NewsRepository newsRepository = NewsRepository();
  final BehaviorSubject<SourceResponse> _subject =
  BehaviorSubject<SourceResponse>();

  getSources() async {
    SourceResponse response = await newsRepository.getSources();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<SourceResponse> get subject => _subject;
}

final getSourcesBloc = GetSourcesBloc();