import 'package:flutter_bloc/flutter_bloc.dart';

// 番茄 事件
class TomatoEvent {}

// 添加新番茄 事件
class AddTomatoEvent extends TomatoEvent {
  Tomato tomato;

  AddTomatoEvent(this.tomato);
}

// 添加新番茄 事件
class UpdateTomatoEvent extends TomatoEvent {
  Tomato tomato;
  UpdateTomatoEvent(this.tomato);
}

// 添加新番茄 事件
class DeleteTomatoEvent extends TomatoEvent {
  int tomatoId;
  DeleteTomatoEvent(this.tomatoId);
}

class Tomato {
  int id;
  String name;
  String description;
  DateTime startTime;
  Duration workDuration;
  Duration restDuration;

  Tomato({
    this.name,
    this.description,
    this.workDuration,
    this.restDuration,
  }) : startTime = DateTime.now();

  Tomato copyWith(Tomato newTomato) {
    return Tomato(
      name: newTomato.name ?? this.name,
      description: newTomato.description ?? this.description,
      workDuration: newTomato.workDuration ?? this.workDuration,
      restDuration: newTomato.restDuration ?? this.restDuration,
    );
  }
}

class TomatoBloc extends Bloc<TomatoEvent, List<Tomato>> {
  @override
  List<Tomato> get initialState => [
        Tomato(
          name: "Hello",
          description: "Hello World",
          workDuration: Duration(minutes: 10),
          restDuration: Duration(minutes: 5),
        ),
      ];

  @override
  Stream<List<Tomato>> mapEventToState(TomatoEvent event) async* {
    if (event is AddTomatoEvent) {
      yield List<Tomato>.from(state)..add(event.tomato);
    } else if (event is UpdateTomatoEvent) {
      var index = state.indexWhere((element) => element.id == event.tomato.id);
      yield [
        ...state.sublist(0, index),
        state[index].copyWith(event.tomato),
        ...state.sublist(index + 1)
      ];
    } else if (event is DeleteTomatoEvent) {
      yield List<Tomato>.from(state)
        ..removeWhere((element) => element.id == event.tomatoId);
    }
  }
}
