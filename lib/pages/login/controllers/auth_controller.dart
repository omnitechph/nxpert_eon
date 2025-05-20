import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_api_service.dart';
import '../models/auth_model.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AuthModel build() => const AuthModel(status: AuthStatus.initial);

  Future<void> login(String userId, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final AuthApiService api = ref.read(authApiServiceProvider);
      final Map<String, dynamic> response = await api.login(userId, password);
      if(response.isNotEmpty){
        final Box<dynamic> box = Hive.box('auth');
        await box.put('status', response['status']);
        await box.put('userId', response['user_id']);
        await box.put('user', '${response['first_name']} ${response['last_name']}');
        state = state.copyWith(status: AuthStatus.success, token: response['status'], userId: response['user_id'], user: '${response['first_name']} ${response['last_name']}');
      }
      else if(response.isEmpty){
        state = state.copyWith(status: AuthStatus.failure, error:null);
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.failure, error: e.toString());
    }
  }
}