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
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
            child: TextFormField(
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
              onPressed: submit,
            ),
          ),
        ],
      ),
    );
  }
}
