import 'package:chai_coffee/CommonUI/FancyMenu.dart';
import 'package:chai_coffee/Models/coffee.dart';
import 'package:chai_coffee/Screens/Home/satting_form.dart';
import 'package:chai_coffee/Services/auth.dart';
import 'package:chai_coffee/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'coffeeList.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {

    void _showSettingPanel(){
      showModalBottomSheet(
          context: context,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          builder: (context) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
            child: SettingForm(),
          ),
        );
      });
    }

    return StreamProvider<List<Coffee>>.value(
      value: DatabaseService().coffee,
      child: Scaffold(
          backgroundColor: Colors.brown[100],
          appBar: AppBar(
            title: Text("Chai Coffee"),
            elevation: 0,
            backgroundColor: Colors.brown[400],
            actions: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SimpleAccountMenu(
                  icons: [Icon(Icons.logout), Icon(Icons.settings)],
                  iconColor: Colors.white,
                  backgroundColor: Colors.pink,
                  onChange: (index) async {
                    if(index == 0) {
                      await _auth.signOut();
                    } else {
                      _showSettingPanel();
                    }
                    print(index);
                  },
                ),
              ),
            ],
          ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Assets/coffee_bg.png'),
              fit: BoxFit.fill
            )
          ),
            child: CoffeeList()
        ),
      ),
    );
  }
}
