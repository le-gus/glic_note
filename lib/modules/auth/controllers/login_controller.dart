import 'package:firebase_auth/firebase_auth.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // sucesso
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Erro ao fazer login';
    } catch (e) {
      return 'Erro inesperado';
    }
  }
}
