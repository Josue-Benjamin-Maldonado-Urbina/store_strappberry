import '../../data/user_repository.dart';

class LoginUseCase {
  final UserRepository userRepository;

  LoginUseCase(this.userRepository);

  Future<Map<String, dynamic>?> execute(String username, String password) {
    return userRepository.loginUser(username, password);
  }
}
