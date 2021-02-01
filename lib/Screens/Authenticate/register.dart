import 'package:chai_coffee/CommonUI/constants.dart';
import 'package:chai_coffee/CommonUI/loding.dart';
import 'package:chai_coffee/Services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.brown[400],
        title: Text("Register to Chai Coffee"),
        actions: [
          FlatButton.icon(
            onPressed: () async {
              widget.toggleView();
            },
            icon: Icon(Icons.person),
            label: Text("Sign in"),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20,),
              TextFormField(
                validator: (val) => val.isEmpty ? "Enter an Email" : null,
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                onChanged: (val){
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                validator: (val) => val.length < 6 ? "Enter Password 6+ char long" : null,
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                onChanged: (val){
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 10,),
              RaisedButton(
                child: Text(
                  "Register",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                  ),
                ),
                color: Colors.pink[400],
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    setState(() => loading = true);
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                    if(result == null){
                      setState(() {
                        error = 'Please Enter Valid Email or Password';
                        loading = false;
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 20,),
              Text(
                error,
                style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 16
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
