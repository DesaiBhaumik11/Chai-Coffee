import 'package:chai_coffee/Models/coffee.dart';
import 'package:chai_coffee/Models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  //Collection reference
  final CollectionReference coffeeCollection = FirebaseFirestore.instance.collection('coffee');

  Future updateUserData(String sugars, String name, int strength) async {
    return await coffeeCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  //coffee list from snapshot
  List<Coffee> _coffeeFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Coffee(
        sugars: doc.data()['sugars'] ?? '0',
        name: doc.data()['name'] ?? '',
        strength: doc.data()['strength'] ?? 0,
      );
    }).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data()['name'],
      sugars: snapshot.data()['sugars'],
      strength: snapshot.data()['strength'],
    );
  }

  //get user data
  Stream<UserData> get userData{
    return coffeeCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //get coffee stream
  Stream<List<Coffee>> get coffee {
    return coffeeCollection.snapshots().map(_coffeeFromSnapshot);
  }
}