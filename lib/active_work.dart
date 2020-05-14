import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywork/tomato_bloc.dart';
import 'package:mywork/work_state.dart';
import './counter.dart';

class WorkForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WorkFormState();
}

class WorkFormState extends State<WorkForm> {
  String workContent = "";
  final formKey = GlobalKey<FormState>();

  void submit(BuildContext context) {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      //ignore: close_sinks
      var bloc = BlocProvider.of<ActiveTomatoBloc>(context);
      bloc.add(UpdateActiveTomatoEvent(Tomato(
        name: workContent,
        workDuration: Duration(minutes: 30),
        restDuration: Duration(minutes: 5),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          Counter(
            duration: Duration(minutes: 20),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
            child: TextFormField(
              validator: (val) => val.isEmpty ? "任务描述不能为空" : null,
              decoration: const InputDecoration(
                hintText: "请输入任务...",
                border: OutlineInputBorder(),
              ),
              onSaved: (val) => workContent = val,
            ),
          ),
          SizedBox(
            width: 200,
            height: 50,
            child: RaisedButton(
              child: Text(
                "开始工作",
                style: TextStyle(fontSize: 14),
              ),
              color: Color(0xFF006dcc),
              highlightColor: Color(0xFF0044cc),
              textColor: Colors.white,
              onPressed: () => submit(context),
            ),
          ),
        ],
      ),
    );
  }
}

class ActiveWork extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ActiveWorkState();
}

class ActiveWorkState extends State<ActiveWork> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveTomatoBloc, Tomato>(
      builder: (context, state) {
        return state == null ? WorkForm() : WorkState(state);
      },
    );
  }
}
