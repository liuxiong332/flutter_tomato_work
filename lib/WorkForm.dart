import 'package:flutter/material.dart';

class WorkForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WorkFormState();
}

class WorkFormState extends State<WorkForm> {
  String workName = "";
  String workContent = "";
  final formKey = GlobalKey<FormState>();

  void submit() {
    final form = formKey.currentState;
    if (workName.isEmpty && workContent.isNotEmpty) {
      setState(() {
        workName = workContent;
      });
    } else if (workName.isNotEmpty && workContent.isEmpty) {
      setState(() {
        workContent = workName;
      });
    }
    if (form.validate()) {
      form.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (val) => val.isEmpty ? "请输入番茄名字" : null,
              onSaved: (val) => workName = val,
              decoration:
                  const InputDecoration(hintText: "输入番茄名字", labelText: "番茄名字"),
            ),
            TextFormField(
              decoration:
                  const InputDecoration(hintText: "输入番茄内容", labelText: "番茄内容"),
              onSaved: (val) => workContent = val,
            ),
            RaisedButton(
              child: Text("创建"),
              onPressed: submit,
            ),
          ],
        ),
      ),
    );
  }
}
