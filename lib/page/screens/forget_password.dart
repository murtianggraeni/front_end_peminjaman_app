import 'package:build_app/page/widget/custom_scaffold.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formForgetPassword = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Column(
      children: [
        const Expanded(
          child: SizedBox(height: 10),
        ),
        Expanded(
          flex: 7,
          child: Container(
            padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                )),
            child: SingleChildScrollView(
              child: Form(
                  key: _formForgetPassword,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [TextFormField()],
                  )),
            ),
          ),
        )
      ],
    ));
  }
}
