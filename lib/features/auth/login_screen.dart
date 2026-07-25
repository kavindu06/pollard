import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pollard/features/shell/main_shell.dart';
import 'package:pollard/theme/app_theme.dart';

class Login_Screen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _Login_ScreenState createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  final _auth = FirebaseAuth.instance;

  late String email;
  late String password;
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 160.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Welcome back',
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineLg,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Sign in to continue',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMd,
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMd.copyWith(color: AppColors.error),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 48.0,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          try {
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            Navigator.pushReplacementNamed(context, MainShell.id);
                          } catch (e) {
                            setState(() {
                              errorMessage = 'Could not sign in. Please try again.';
                            });
                            print(e);
                          } finally {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.onPrimary,
                          ),
                        )
                      : const Text('Log In'),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
