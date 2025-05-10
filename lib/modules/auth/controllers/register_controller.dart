import 'package:firebase_auth/firebase_auth.dart';

class RegisterController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // sucesso
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Erro ao registrar usuário';
    } catch (e) {
      return 'Erro inesperado';
    }
  }
}
