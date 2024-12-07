import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurUser(){
    return _auth.currentUser;
  }

  Future<UserCredential> signInWithEmailPassword( String email, String password) async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email:email ,
          password: password
      );

      _firestore.collection("Users").doc(userCredential.user!.uid).set(
          {
            'uid': userCredential.user!.uid,
            'email': userCredential.user!.email,
          }
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailPassword (String email, String password) async {
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email:email ,
          password: password,

      );

      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'name' : userCredential.user!.displayName
        }
      );

      return userCredential;

    }on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }

  //google singIN
  Future<UserCredential?> googleSignIn() async {
    try {
      // Начинаем процесс входа через Google
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // Если пользователь отменил вход
      if (gUser == null) return null;

      // Получаем данные авторизации от Google
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Создаем учетные данные для Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Выполняем вход в Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Проверяем, существует ли пользователь в Firestore
      final userDoc = await _firestore.collection('Users').doc(userCredential.user!.uid).get();

      if (!userDoc.exists) {
        // Если запись отсутствует, создаем новую
        await _firestore.collection('Users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'name': userCredential.user!.displayName ?? 'Anonymous', // Если имени нет, задаем дефолтное
          'photoUrl': userCredential.user!.photoURL ?? '', // Фото пользователя, если доступно
          'createdAt': FieldValue.serverTimestamp(), // Время создания
        });
      }

      return userCredential;
    } catch (e) {
      throw Exception('Google Sign-In failed: ${e.toString()}');
    }
  }
  //possible error Messages
  String getErrorMessage(String errorCode) {
   switch(errorCode) {
     case 'Exception wrong-password':
       return 'The password is incorrect. Please try again';
     case 'Exception user-not-found':
       return 'No user fount with this email. Please sign in';
     case 'Exception email does not exist':
       return 'This email does not exist';
     default:
       return 'An unexpected error occured. Pleasy try again later.';
   }
  }

}