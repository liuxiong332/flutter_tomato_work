import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

const WORK_MINUTE = 25;
const REST_MINUTE = 5;

class SettingEvent {}

class UpdateSettingEvent extends SettingEvent {
  UpdateSettingEvent(this.setting);

  Setting setting;
}

class LoadSettingEvent extends SettingEvent {}

class Setting {
  Setting({this.workMinutes, this.restMinutes});

  int workMinutes;
  int restMinutes;

  Setting copyWith(Setting oldSetting) {
    return Setting(
      restMinutes: oldSetting.restMinutes ?? restMinutes,
      workMinutes: oldSetting.workMinutes ?? workMinutes,
    );
  }
}

class SettingBloc extends Bloc<SettingEvent, Setting> {

  SettingBloc(): super() {
    add(LoadSettingEvent());
  }

  @override
  Setting get initialState =>
      Setting(workMinutes: WORK_MINUTE, restMinutes: REST_MINUTE);

  @override
  Stream<Setting> mapEventToState(SettingEvent event) async* {
    if (event is UpdateSettingEvent) {
      var prefs = await SharedPreferences.getInstance();
      var newState = state.copyWith(event.setting);
      prefs.setInt("workMinutes", newState.workMinutes);
      prefs.setInt("restMinutes", newState.restMinutes);
      yield newState;
    } else if (event is LoadSettingEvent) {
      var prefs = await SharedPreferences.getInstance();
      yield Setting(
        workMinutes: prefs.getInt("workMinutes") ?? WORK_MINUTE,
        restMinutes: prefs.getInt("restMinutes") ?? REST_MINUTE,
      );
    }
  }
}
