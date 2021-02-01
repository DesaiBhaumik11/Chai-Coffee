import 'package:chai_coffee/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Authenticate/authenticate.dart';
import 'Home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserFromFirebase>(context);
    print(user);
    if (user == null){
      return Authenticate();
    } else {
      return Home();
    }
  }
}
