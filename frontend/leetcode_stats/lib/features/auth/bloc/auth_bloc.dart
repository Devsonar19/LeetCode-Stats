import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc  extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequest>((event, emit) async {
      emit(AuthLoading());
      try{
        await ApiService.checkUser(event.username);
        final store = await SharedPreferences.getInstance();
        await store.setString("username", event.username);
        emit(AuthSuccess(event.username));
      }catch(e){
        emit(AuthFailure(e.toString()));
      }
    });
    on<LogoutRequest>((event, emit) async{
      final store = await SharedPreferences.getInstance();
      await store.remove("username");
      emit(Loggout());
    });
  }
}