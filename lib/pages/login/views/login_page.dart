import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/text_fields/custom_text_field.dart';
import '../controllers/auth_controller.dart';
import '../models/auth_model.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _userIdFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _userIdFocus.requestFocus());
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    _userIdFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _handleSubmit(){
    ref.read(authControllerProvider.notifier).login(_userIdController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthModel>(authControllerProvider, (AuthModel? previous, AuthModel next) {
      if (next.status == AuthStatus.loading) {
        showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
      } else {
        if (Navigator.canPop(context)) Navigator.pop(context);
      }

      if (next.status == AuthStatus.success) {
        context.go('/ppm/production-management');
      }

      if (next.status == AuthStatus.failure) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text("Login Failed"),
              content: Text(next.error.toString().contains('fetch') ? 'Server connection error!' : next.error ?? 'Incorrect userId or password'),
              actions: <Widget>[TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
            );
          },
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF101218),
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 18,
                  children: <Widget>[
                    SizedBox(width: 400, child: Container(margin: const EdgeInsets.all(16), child: Image.asset('assets/images/nxpert_eon.png'))),
                    const Text('NXPERT EON', style: TextStyle(color: Color(0xFFECECEC), fontSize: 32, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 400,
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        color: Colors.grey[300],
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const SizedBox(height: 16),
                              const Text("LOGIN CREDENTIALS", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              CustomTextField(controller: _userIdController, hintText: 'User ID', obscureText: false, focusNode: _userIdFocus, onSubmitted: (_) => _passwordFocus.requestFocus(), radius: 50),
                              const SizedBox(height: 12),
                              CustomTextField(
                                controller: _passwordController,
                                hintText: 'Password',
                                obscureText: true,
                                showPassword: _showPassword,
                                onToggle: () => setState(() => _showPassword = !_showPassword),
                                focusNode: _passwordFocus,
                                onSubmitted: (_) => _handleSubmit(),
                                radius: 50,
                              ),
                              const SizedBox(height: 24),
                              CustomButton(text: 'LOGIN', onTap: _handleSubmit),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF3F4454),
        padding: const EdgeInsets.all(8.0),
        child: const Text('Ver. IT002', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFECECEC), fontSize: 16)),
      ),
    );
  }
}
