import '../../data/user_repository.dart';

class RegisterUseCase {
  final UserRepository userRepository;

  RegisterUseCase(this.userRepository);

  Future<int?> execute(String username, String password, bool isAdmin) async {
    return await userRepository.registerUser(username, password, isAdmin);
  }
}
