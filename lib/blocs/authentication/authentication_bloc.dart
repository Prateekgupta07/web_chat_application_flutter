import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import '../../services/auth_service.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService authService;

  AuthenticationBloc(this.authService) : super(AuthenticationInitial()) {
    on<AuthenticationStarted>(_onAuthenticationStarted);
    on<AuthenticationLoggedOut>(_onAuthenticationLoggedOut);
  }

  Future<void> _onAuthenticationStarted(AuthenticationStarted event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    final isSignedIn = await authService.signUp(event.username, event.password);
    if (isSignedIn) {
      emit(AuthenticationSuccess());
    } else {
      emit(AuthenticationFailure());
    }
  }

  Future<void> _onAuthenticationLoggedOut(AuthenticationLoggedOut event, Emitter<AuthenticationState> emit) async {
    await authService.logout();
    emit(AuthenticationInitial());
  }
}
