import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool check = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body : LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Positioned(
                                top:0,
                                left: 20,
                                child: IconButton(
                                    icon: Icon(Icons.arrow_back_ios),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                            ),
                            _inputForm(size),
                            _authButton(size),
                          ],
                        ),
                      ],
                    )
                ),
              ),
            );
        }
      ));
  }


  Widget _inputForm(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 120,
          bottom: 120,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "이메일",
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "이메일을 적어주세요.";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "비밀번호(8~20자리)",
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "비밀번호를 적어주세요.";
                  } else {
                    return null;
                  }
                },
              ),
              Container(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: check,
                    onChanged: (bool newValue) {
                    setState(() {
                          check = newValue;
                        });
                      },
                    ),
                    Text("자동로그인"),
                ]
               )
            ],
          ),
        ),
      ),
    );
  }

  Widget _authButton(Size size) =>
      Positioned(
        left: size.width * 0.07,
        right: size.width * 0.07,
        bottom: 20,
        child: Container(
          width: size.width*0.9,
          height: size.width*0.12,
          child: RaisedButton(
            child: Text("로그인", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w800, fontSize: 18),),
            color: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            onPressed: () {
              print('${_emailController.text}');
              print('${_passwordController.text}');
            },
          ),
        ),
      );

}


