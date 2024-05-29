// domain/repositories/user_repository.dart
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/data/models/user_data_model.dart';
import 'package:ecommerce_app/data/source/local/local_user_data_source.dart';
import 'package:ecommerce_app/data/source/remote/remote_user_data_source.dart';
import 'package:ecommerce_app/utils/log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class UserDataModelRepository {
  Future<Either<Exception, void>> registerUser(UserDataModel user);
  Future<Either<Exception, UserDataModel>> emailLoginUser(String email, String password);
  Future<Either<Exception, UserDataModel>> googleLoginUser();
  Future<Either<Exception, UserDataModel>> getUserData(String userEmail);
}

class UserDataModelRepositoryImpl implements UserDataModelRepository {
  final RemoteUserDataSource remoteDataSource;
  final LocalUserDataSource localDataSource;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  UserDataModelRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Exception, void>> registerUser(UserDataModel user) async {
    try {
      await remoteDataSource.registerUser(user);
      await localDataSource.registerUser(UserDataModel.fromDomain(user));
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to register user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, UserDataModel>> emailLoginUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.signOut();
      final auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserDataModel(
        userName: auth.user!.displayName ?? 'No Name',
        userEmail: email,
        userProfPicUrl: auth.user!.photoURL,
      );

      return Right(user);
    } catch (e) {
      return Left(Exception('Failed to log in user'));
    }
  }
  
  @override
  Future<Either<Exception, UserDataModel>> googleLoginUser() async {
    try {
      Log.yellow("GOOGLE LOGIN");
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn().catchError(
        (error) {
          Log.red(error.toString());
          return error;
        },
      );
      if (googleUser == null) {
        Log.red("Google sign-in aborted");
        return Left(Exception('Google sign-in aborted'));
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = authResult.user;

      if (user != null) {
        final domainUser = UserDataModel(
          userName: user.displayName ?? 'No Name',
          userEmail: user.email!,
          userProfPicUrl: user.photoURL,
        );

        Log.yellow("USER NAME ::: ${domainUser.userName}");
        await remoteDataSource.registerUser(domainUser);
        await localDataSource.registerUser(UserDataModel.fromDomain(domainUser));

        return Right(domainUser);
      } else {
        return Left(Exception('Failed to log in with Google'));
      }
    } catch (e) {
      return Left(Exception('Failed to log in with Google'));
    }
  }
  
  @override
  Future<Either<Exception, UserDataModel>> getUserData(String userEmail) async {

    try {
      var res = localDataSource.getUserData(userEmail);
      if (res.userEmail.isEmpty) {
        Log.yellow("Local User Data is empty");
        res = await remoteDataSource.getUserData(userEmail);
        await localDataSource.registerUser(UserDataModel.fromDomain(res));
      }
      return Right(res);
    } catch (e) {
      return Left(Exception('Failed to get user data'));
    }
  }
}