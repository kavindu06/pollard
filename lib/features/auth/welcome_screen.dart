import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pollard/features/auth/login_screen.dart';
import 'package:pollard/theme/app_theme.dart';
import 'registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Welcome_Screen extends StatelessWidget {
  static const String id = 'welcome_screen';

  const Welcome_Screen({super.key});

  static const _brandTextStyle = TextStyle(
    fontFamily: AppTextStyles.fontFamily,
    fontSize: 36.0,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  void _showComingSoon(BuildContext context, String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$provider sign-in is coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                    height: 120.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: DefaultTextStyle(
                    style: _brandTextStyle,
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [TypewriterAnimatedText('VendSmart')],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Smart billing & inventory, simplified.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMd,
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, Login_Screen.id),
                    child: const Text('Log In'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 48.0,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, Registration_Screen.id),
                    child: const Text('Register'),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: <Widget>[
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      child: Text('or continue with', style: AppTextStyles.labelMd),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _SocialButton(
                      icon: FontAwesomeIcons.google,
                      iconColor: const Color(0xFFDB4437),
                      onTap: () => _showComingSoon(context, 'Google'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _SocialButton(
                      icon: FontAwesomeIcons.facebookF,
                      iconColor: const Color(0xFF1877F2),
                      onTap: () => _showComingSoon(context, 'Facebook'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _SocialButton(
                      icon: FontAwesomeIcons.apple,
                      iconColor: AppColors.onSurface,
                      onTap: () => _showComingSoon(context, 'Apple'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(side: BorderSide(color: AppColors.outlineVariant)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 52.0,
          height: 52.0,
          child: Center(child: FaIcon(icon, size: 20.0, color: iconColor)),
        ),
      ),
    );
  }
}
