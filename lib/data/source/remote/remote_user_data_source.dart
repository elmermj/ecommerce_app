// data/datasources/user_remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/models/user_data_model.dart';

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
    await firestore.collection('users').doc(user.userEmail).set({
      'userName': user.userName,
      'userProfPicUrl': user.userProfPicUrl,
      'userEmail': user.userEmail,
    });
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
