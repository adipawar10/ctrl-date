/// ctrl^date - Auth Screen
/// Landing screen with sign in, sign up, and OAuth options
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../theme.dart';

/// Authentication landing screen
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // App logo placeholder
              Center(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  child: const Icon(
                    Icons.calendar_month,
                    size: 80,
                    color: AppColors.black,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // App title
              Text(
                'ctrl^date',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.sm),

              // Tagline
              Text(
                'Plan smarter. Reflect deeper. Achieve more.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // Sign In button
              ElevatedButton(
                onPressed: () => context.push('/sign-in'),
                child: const Text('Sign In'),
              ),

              const SizedBox(height: AppSpacing.md),

              // Sign Up button
              OutlinedButton(
                onPressed: () => context.push('/sign-up'),
                child: const Text('Sign Up'),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Divider with text
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      'or',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Continue with Google button
              OutlinedButton.icon(
                onPressed: () => _signInWithGoogle(context),
                icon: Image.network(
                  'https://www.google.com/favicon.ico',
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.g_mobiledata,
                    size: 20,
                    color: AppColors.black,
                  ),
                ),
                label: const Text('Continue with Google'),
              ),

              const Spacer(),

              // Terms and privacy
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.gray500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connecting to Google...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      final authService = AuthService.instance;
      final result = await authService.signInWithGoogle();

      if (!context.mounted) return;

      result.when(
        success: (user, session, message) {
          // OAuth flow initiated - user will be redirected back after auth
          if (message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
          // If session is available, navigate to calendar
          if (session != null) {
            context.go('/calendar');
          }
        },
        failure: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google sign-in failed: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
