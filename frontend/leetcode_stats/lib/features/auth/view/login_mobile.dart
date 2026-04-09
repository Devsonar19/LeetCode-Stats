import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                  builder: (_) =>
                  AlertDialog(
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "LeetCode Stats",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      "A companion app for your daily coding\nprogress right in your pocket.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 48),


                    Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Username Text Field
                          TextField(
                            controller: controller,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: "Enter your username",
                              hintStyle: TextStyle(color: Colors.grey.shade700),
                              prefixIcon: const Icon(Icons.person_outline, color: Colors.black),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 18),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.black87, width: 2),
                              ),
                            ),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Enter Button
                          ElevatedButton(
                            onPressed: () {
                              final username = controller.text.trim();
                              if(username.isEmpty) return;
                              context.read<AuthBloc>().add(LoginRequest(username));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: state is AuthLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                              "Enter Dashboard",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
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
