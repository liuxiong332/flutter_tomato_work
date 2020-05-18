import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywork/tomato_store.dart';

// 番茄记录 事件
class TomatoRecordEvent {}

// 添加历史番茄记录 事件
class AddTomatoEvent extends TomatoRecordEvent {
  Tomato tomato;

  AddTomatoEvent(this.tomato);
}

class BatchAddTomatoEvent extends TomatoRecordEvent {
  List<Tomato> tomatos;

  BatchAddTomatoEvent(this.tomatos);
}

// 更新历史番茄记录 事件
class UpdateTomatoEvent extends TomatoRecordEvent {
  Tomato tomato;
  UpdateTomatoEvent(this.tomato);
}

// 删除历史番茄 事件
class DeleteTomatoEvent extends TomatoRecordEvent {
  int tomatoId;
  DeleteTomatoEvent(this.tomatoId);
}

// 一个番茄工作类
class Tomato {
  int id;
  String name;
  DateTime startTime;
  Duration workDuration;
  Duration restDuration;
  DateTime stopTime;

  Tomato({
    this.name,
    this.workDuration,
    this.restDuration,
  }) : startTime = DateTime.now();

  Tomato.all({
    this.name,
    this.startTime,
    this.workDuration,
    this.restDuration,
    this.stopTime,
  });

  Tomato copyWith(Tomato newTomato) {
    return Tomato(
      name: newTomato.name ?? this.name,
      workDuration: newTomato.workDuration ?? this.workDuration,
      restDuration: newTomato.restDuration ?? this.restDuration,
    );
  }
}

// 番茄历史记录 Bloc，增加/删除/更新 历史记录
class TomatoRecordBloc extends Bloc<TomatoRecordEvent, List<Tomato>> {
  TomatoStore tomatoStore;

  TomatoRecordBloc() : super() {
    tomatoStore = TomatoStore();
    tomatoStore.init().then((value) => tomatoStore
        .getRecords()
        .then((value) => add(BatchAddTomatoEvent(value))));
  }

  @override
  List<Tomato> get initialState => [
        Tomato(
          name: "Hello",
          workDuration: Duration(minutes: 10),
          restDuration: Duration(minutes: 5),
        ),
      ];

  @override
  Stream<List<Tomato>> mapEventToState(TomatoRecordEvent event) async* {
    if (event is AddTomatoEvent) {
      // Insert the record
      await tomatoStore.insertRecord(event.tomato);
      yield List<Tomato>.from(state)..add(event.tomato);
    } else if (event is BatchAddTomatoEvent) {
      yield event.tomatos;
    } else if (event is UpdateTomatoEvent) {
      // This event is not used now
      var index = state.indexWhere((element) => element.id == event.tomato.id);
      yield [
        ...state.sublist(0, index),
        state[index].copyWith(event.tomato),
        ...state.sublist(index + 1)
      ];
    } else if (event is DeleteTomatoEvent) {
      // The remove is not used now.
      yield List<Tomato>.from(state)
        ..removeWhere((element) => element.id == event.tomatoId);
    }
  }
}

// 更新当前使用的番茄 属性
class ActiveTomatoEvent {}

class UpdateActiveTomatoEvent extends ActiveTomatoEvent {
  Tomato tomato;

  UpdateActiveTomatoEvent(this.tomato);
}

class ResetActiveTomatoEvent extends ActiveTomatoEvent {}

// 当前使用番茄 bloc
class ActiveTomatoBloc extends Bloc<ActiveTomatoEvent, Tomato> {
  @override
  Tomato get initialState => Tomato();

  @override
  Stream<Tomato> mapEventToState(ActiveTomatoEvent event) async* {
    if (event is UpdateActiveTomatoEvent) {
      yield state == null ? event.tomato : state.copyWith(event.tomato);
    } else if (event is ResetActiveTomatoEvent) {
      yield Tomato();
    }
  }
}
