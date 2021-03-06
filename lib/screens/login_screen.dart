import 'package:flutter/material.dart';
import 'package:bef/screens/signup_screen.dart';
import 'package:bef/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  _showErrorDialog(String code) {
    String error;
    switch (code) {
      case "ERROR_INVALID_EMAIL":
        error = 'Địa chỉ Email không hợp lệ!';

        break;
      case "ERROR_USER_NOT_FOUND":
        error = 'Tài khoản không tồn tại!';

        break;
      case "ERROR_WRONG_PASSWORD":
        error = 'Sai mật khẩu!';

        break;
      case "ERROR_USER_DISABLED":
        error = 'Tài khoản bị khóa';

        break;
    }
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              error,
              style: TextStyle(color: Colors.red),
            ),
            title: Text('Lỗi đăng nhập'),
            actions: <Widget>[
              FlatButton(
                  child: const Text('Hủy'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // Logging in the user w/ Firebase
      String _catch = await AuthService.login(_email, _password);
      if (_catch != '') _showErrorDialog(_catch);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[400],
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'BeF',
                style: TextStyle(
                  fontFamily: 'Billabong',
                  fontSize: 160.0,
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Billabong',
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (input) =>
                            !input.contains('@') ? 'Email không hợp lệ' : null,
                        onSaved: (input) => _email = input,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Billabong',
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (input) => input.length < 6
                            ? 'Password phải ít nhất 6 kí tự'
                            : null,
                        onSaved: (input) => _password = input,
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 125.0,
                      child: FlatButton(
                        onPressed: _submit,
                        color: null,
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Đăng nhập',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 250.0,
                      child: FlatButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, SignupScreen.id),
                        color: null,
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Chưa có tài khoản? Đăng ký ngay.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
