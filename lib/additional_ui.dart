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

class OtherButton extends StatelessWidget {
  OtherButton({this.text, this.onPressed});

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 30,
      child: RaisedButton(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        color: Color(0xFF49afcd),
        highlightColor: Color(0xFF49afcd),
        textColor: Colors.white,
        onPressed: onPressed,
      ),
    );
  }
}

// 设置对话框
class SettingDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingDialogState();
  }
}

class SettingDialogState extends State<SettingDialog> {
  final formKey = GlobalKey<FormState>();

  int curWorkMinutes;
  int curRestMinutes;

  void handleOK() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      // ignore: close_sinks
      final bloc = BlocProvider.of<SettingBloc>(context);
      bloc.add(UpdateSettingEvent(Setting(
        workMinutes: curWorkMinutes,
        restMinutes: curRestMinutes,
      )));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<SettingBloc>(context);

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
                  curWorkMinutes = int.parse(val);
                },
              ),
              SettingInput(
                hintText: "休息时长",
                initialVal: bloc.state.restMinutes,
                onSaved: (val) {
                  curRestMinutes = int.parse(val);
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
  }
}

class AdditionalUIState extends State<AdditionalUI> {
  void showSettingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SettingDialog();
      },
    );
  }

  void showHistory() {
    Navigator.of(context).pushNamed("history");
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    return Column(children: [
      Row(children: [
        Column(children: [
          Flex(direction: Axis.horizontal, children: [
            OtherButton(
              text: "设置",
              onPressed: () => showSettingDialog(),
            ),
            OtherButton(
              text: "任务记录",
              onPressed: () => showHistory(),
            ),
          ]),
        ])
      ]),
    ]);
  }
}
