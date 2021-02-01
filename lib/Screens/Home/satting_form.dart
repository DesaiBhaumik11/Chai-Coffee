import 'package:chai_coffee/CommonUI/constants.dart';
import 'package:chai_coffee/CommonUI/loding.dart';
import 'package:chai_coffee/Models/user.dart';
import 'package:chai_coffee/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingForm extends StatefulWidget {
  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4', '5'];

  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserFromFirebase>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text('Update your coffee setting',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[900],
                        fontWeight: FontWeight.w600
                      )
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: userData.name,
                    validator: (val) => val.isEmpty ? "Enter an Name" : null,
                    decoration: textInputDecoration.copyWith(hintText: 'Name'),
                    onChanged: (val) {
                      setState(() => _currentName != null ? _currentName = val : _currentName = userData.name);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                      decoration: textInputDecoration,
                      value: _currentSugars ?? userData.sugars,
                      items: sugars.map((sugars) {
                        return DropdownMenuItem(
                            value: sugars, child: Text("$sugars sugars"));
                      }).toList(),
                      onChanged: (val) => setState(() => _currentSugars = val)),
                  SizedBox(
                    height: 20,
                  ),
                  Slider(
                    value: (_currentStrength ?? userData.strength).toDouble(),
                    activeColor: Colors.brown[_currentStrength ?? userData.strength],
                    inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
                    min: 100.0,
                    max: 900.0,
                    divisions: 8,
                    onChanged: (val) => setState (() => _currentStrength = val.round()),
                  ),
                  SizedBox(height: 10,),
                  RaisedButton(
                    child: Text(
                      "Update",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    color: Colors.pink[400],
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                            _currentSugars ?? userData.sugars,
                            _currentName ?? userData.name,
                            _currentStrength ?? userData.strength
                        );
                        Navigator.pop(context);
                        // setState(() => loading = true);
                        // dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                        // if(result == null){
                        //   setState(() {
                        //     error = 'Please Enter Valid Email or Password';
                        //     loading = false;
                        //   });
                        // }
                      }
                    },
                  ),
                ],
              ));
        } else {
          return Loading();
        }
      }
    );
  }
}
