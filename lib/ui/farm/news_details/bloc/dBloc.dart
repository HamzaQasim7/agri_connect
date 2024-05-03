import 'package:flutter_bloc/flutter_bloc.dart';

import 'dEvent.dart';
import 'dState.dart';

//
// class DetailBloc extends Bloc<NewsDetailEvent, DetailState> {
//   DetailBloc(DetailState initialState) : super(initialState);
//   on<NewsDetailEvent>((event, emit)  {
//   mapEventToState(event);
//   }
//
//   @override
//   DetailState get initialState => LoadingDetail();
//
//   @override
//   Stream<DetailState> mapEventToState(NewsDetailEvent event) async* {
//     if (event is SelectNewsForDetail) {
//       try {
//         yield LoadedArticle(selectedArticle: event.article);
//       } catch (_) {
//         yield FailureDetail();
//       }
//     }
//   }
// }
class DetailBloc extends Bloc<NewsDetailEvent, DetailState> {
  DetailBloc(DetailState initialState) : super(initialState) {
    // @override
    // DetailState get initialState => LoadingDetail();
    on<SelectNewsForDetail>((event, emit) {
      // Handle the SelectNewsForDetail event here
      // Call emit to update the state
      try {
        emit(LoadedArticle(selectedArticle: event.article));
      } catch (_) {
        emit(FailureDetail());
      }
    });
  }
}

// class DetailBloc extends Bloc<NewsDetailEvent, DetailState> {
//   DetailBloc(DetailState initialState) : super(initialState);
//
//   @override
//   DetailState get initialState => LoadingDetail();
//
//   @override
//   Stream<DetailState> mapEventToState(NewsDetailEvent event) async* {
//     // Register the event handler using the new method
//     on<SelectNewsForDetail>((event, emit) async* {
//       try {
//         yield LoadedArticle(selectedArticle: event.article);
//       } catch (_) {
//         yield FailureDetail();
//       }
//     });
//   }
// }
