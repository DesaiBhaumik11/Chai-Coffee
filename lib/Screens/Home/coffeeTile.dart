import 'package:chai_coffee/Models/coffee.dart';
import 'package:flutter/material.dart';

class CoffeeTile extends StatelessWidget {
  final Coffee coffee;

  CoffeeTile({this.coffee});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left:20, right:20, top:20),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage("Assets/coffee_icon.png",),
          radius: 25,
          backgroundColor: Colors.brown[coffee.strength],
        ),
        title: Text(coffee.name),
        subtitle: Text("Takes ${coffee.sugars} sugars"),
      ),
    );
  }
}
