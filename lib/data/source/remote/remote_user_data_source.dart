// data/datasources/user_remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/models/user_data_model.dart';
import 'package:ecommerce_app/utils/log.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class RemoteUserDataSource {
  Future<void> registerUser(UserDataModel user);
  Future<void> updateUser(UserDataModel user);
  Future<void> createUser(UserDataModel user);
  Future<void> deleteUser(UserDataModel user);

  Future<UserDataModel> getUserData(String userEmail);
}

class RemoteUserDataSourceImpl implements RemoteUserDataSource {
  final FirebaseFirestore firestore;

  RemoteUserDataSourceImpl(this.firestore);

  @override
  Future<void> registerUser(UserDataModel user) async {
    // Ensure that the user is authenticated
    User? currentUser = FirebaseAuth.instance.currentUser;
    Log.yellow("Is Authenticated? ${currentUser != null}");
    if (currentUser != null) {
      // Use the UID as the document ID
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
        'userName': user.userName,
        'userProfPicUrl': user.userProfPicUrl,
        'userEmail': user.userEmail,
      });
      await FirebaseFirestore.instance.collection('users').doc(user.userEmail).collection('shoppingCart').doc('initialCart').set({
        // You can initialize the shopping cart with default values if needed
      });

    } else {
      // Handle the case where the user is not authenticated
      throw Exception('User is not authenticated');
    }
  }
  
  @override
  Future<void> updateUser(UserDataModel user) async {
    await firestore.collection('users').doc(user.userEmail).update({
      'userName': user.userName,
      'userProfPicUrl': user.userProfPicUrl,
      'userEmail': user.userEmail,
    });
  }

  @override
  Future<void> createUser(UserDataModel user) async {
    await firestore.collection('users').doc(user.userEmail).set({
      'userName': user.userName,
      'userProfPicUrl': user.userProfPicUrl,
      'userEmail': user.userEmail,
    });
  }

  @override
  Future<void> deleteUser(UserDataModel user) async {
    await firestore.collection('users').doc(user.userEmail).delete();
  }
  
  @override
  Future<UserDataModel> getUserData(String userEmail) {
    return firestore.collection('users').doc(userEmail).get().then((doc) {
      return UserDataModel(
        userName: doc.get('userName'),
        userProfPicUrl: doc.get('userProfPicUrl'),
        userEmail: doc.get('userEmail'),
      );
    });
  }
  
}
