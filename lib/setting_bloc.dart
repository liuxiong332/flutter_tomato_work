import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateSettingEvent {
  UpdateSettingEvent(this.setting);

  Setting setting;
}

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

class SettingBloc extends Bloc<UpdateSettingEvent, Setting> {
  @override
  Setting get initialState => Setting(workMinutes: null, restMinutes: null);

  @override
  Stream<Setting> mapEventToState(UpdateSettingEvent event) async* {
    yield state.copyWith(event.setting);
  }
}
