import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc  extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequest>((event, emit) async {
      emit(AuthLoading());

      try{
        await ApiService.checkUser(event.username);
        emit(AuthSuccess(event.username));
      }catch(e){
        emit(AuthFailure(e.toString()));
      }
    });
    on<LogoutRequest>((event, emit) {
      emit(Loggout());
    });
  }
}