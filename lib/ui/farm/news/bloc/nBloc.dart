import 'package:farmassist/data/farm/resources/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'nEvent.dart';
import 'nState.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final Repository repository;

  NewsBloc({required this.repository}) : super(Loading()) {
    on<Fetch>((event, emit) async {
      try {
        emit(Loading());
        final items = await repository.fetchAllNews(category: event.type);
        emit(Loaded(items: items!, type: event.type));
      } catch (_) {
        emit(Failure());
      }
    });
  }

  @override
  NewsState get initialState => Loading();
}
