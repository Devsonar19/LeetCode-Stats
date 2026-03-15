import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leetcode_stats/features/auth/bloc/auth_state.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class LoginMobile extends StatefulWidget {
  const LoginMobile({super.key});

  @override
  State<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state){

            if(state is AuthFailure){
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Error"),
                    content: Text(state.error),
                  )
              );
            }

            if(state is AuthSuccess){
              Navigator.pushNamed(
                  context, "/dashboard",
                  arguments: state.username
              );
            }

          },
        builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "LeetCode Stats",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Username",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                        onPressed: (){
                          final username = controller.text.trim();
                          if(username.isEmpty) return;

                          context.read<AuthBloc>().add(LoginRequest(username));
                        },
                        child: state is AuthLoading
                            ? const CircularProgressIndicator()
                            : const Text("Enter"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ]
                )
              ),
            );
        },
      ),
    );
  }
}
