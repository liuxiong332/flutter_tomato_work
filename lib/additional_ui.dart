import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywork/setting_bloc.dart';

class SettingInput extends StatelessWidget {
  SettingInput({this.hintText, this.initialVal, this.onSaved});

  final String hintText;
  final Function onSaved;
  final int initialVal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: SizedBox(
        width: 300,
        child: TextFormField(
          initialValue: initialVal != null ? initialVal.toString() : "",
          validator: (val) => int.tryParse(val) == null ? "请输入有效的数字" : null,
          autofocus: true,
          decoration: InputDecoration(
            labelText: hintText,
            labelStyle: TextStyle(fontSize: 14),
            hintText: hintText,
            prefixIcon: Icon(Icons.event),
          ),
          keyboardType: TextInputType.number,
          onSaved: onSaved,
        ),
      ),
    );
  }
}

class AdditionalUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AdditionalUIState();
}

class AdditionalUIState extends State<AdditionalUI> {
  int workMinutes;
  int restMinutes;
  final formKey = GlobalKey<FormState>();

  void handleOK() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      // ignore: close_sinks
      final bloc = BlocProvider.of<SettingBloc>(context);
      bloc.add(UpdateSettingEvent(
          Setting(workMinutes: workMinutes, restMinutes: restMinutes)));
      Navigator.of(context).pop();
    }
  }

  void showSettingDialog() {
    // ignore: close_sinks
    final bloc = BlocProvider.of<SettingBloc>(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Form(
            key: formKey,
            child: SizedBox(
              height: 200,
              child: Column(
                children: [
                  SettingInput(
                    hintText: "工作时长",
                    initialVal: bloc.state.workMinutes,
                    onSaved: (val) {
                      workMinutes = int.parse(val);
                    },
                  ),
                  SettingInput(
                    hintText: "休息时长",
                    initialVal: bloc.state.restMinutes,
                    onSaved: (val) {
                      restMinutes = int.parse(val);
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            FlatButton(
              child: Text("确定"),
              onPressed: () => handleOK(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    return Flex(direction: Axis.horizontal, children: [
      RaisedButton(
        child: Text(
          "设置",
          style: TextStyle(fontSize: 14),
        ),
        color: Color(0xFF006dcc),
        highlightColor: Color(0xFF0044cc),
        textColor: Colors.white,
        onPressed: () => showSettingDialog(),
      ),
    ]);
  }
}
