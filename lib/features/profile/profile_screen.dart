import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pollard/features/auth/welcome_screen.dart';
import 'package:pollard/theme/app_theme.dart';
import 'package:pollard/widgets/widgets.dart';

/// Profile & settings screen matching the "profile_settings" reference design:
/// avatar header, settings cards with a footer status line, and a logout button.
class Profile_Screen extends StatelessWidget {
  static const String id = 'profile_screen';
  const Profile_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? user?.email?.split('@').first ?? 'User';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Header: avatar, name, role, id.
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: const Icon(Icons.person,
                        size: 56, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(displayName, style: AppTextStyles.headlineLg),
                const SizedBox(height: AppSpacing.xs),
                Text('Store Manager', style: AppTextStyles.bodyMd),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    user?.email ?? '',
                    style: AppTextStyles.labelMd
                        .copyWith(color: AppColors.onSurface),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Account Settings', style: AppTextStyles.headlineMd),
          const SizedBox(height: AppSpacing.md),
          _SettingsCard(
            icon: Icons.storefront_outlined,
            iconColor: AppColors.primary,
            title: 'Store Profile',
            titleColor: AppColors.primary,
            description:
                'Manage store location, operating hours, and basic tax configurations.',
            footer: 'Pollard Store',
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingsCard(
            icon: Icons.notifications_active_outlined,
            iconColor: AppColors.tertiary,
            title: 'Notification Settings',
            titleColor: AppColors.tertiary,
            description:
                'Configure stock alerts, end-of-day summaries, and staff messages.',
            footer: 'Alerts enabled',
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingsCard(
            icon: Icons.lock_outline,
            iconColor: AppColors.onSurface,
            title: 'Security & Password',
            titleColor: AppColors.onSurface,
            description:
                'Update POS PIN, manager override codes, and account password.',
            footer: 'Update password',
            footerColor: AppColors.error,
            footerIcon: Icons.warning_amber_outlined,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingsCard(
            icon: Icons.language_outlined,
            iconColor: AppColors.onSurface,
            title: 'Language & Region',
            titleColor: AppColors.onSurface,
            description:
                'Set system language, currency format, and timezone preferences.',
            footer: 'EN-US / LKR',
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.lg),
          // Logout.
          Material(
            color: AppColors.errorContainer,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Welcome_Screen.id, (route) => false);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: AppColors.error, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Logout',
                      style: AppTextStyles.bodyLg.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final String description;
  final String footer;
  final Color footerColor;
  final IconData? footerIcon;
  final VoidCallback onTap;

  const _SettingsCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.titleColor,
    required this.description,
    required this.footer,
    this.footerColor = AppColors.onSurfaceVariant,
    this.footerIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor, size: 24),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    title,
                    style: AppTextStyles.headlineMd
                        .copyWith(fontSize: 18, color: titleColor),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(description, style: AppTextStyles.bodyMd),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  if (footerIcon != null) ...[
                    Icon(footerIcon, size: 16, color: footerColor),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Expanded(
                    child: Text(
                      footer.toUpperCase(),
                      style: AppTextStyles.labelMd.copyWith(color: footerColor),
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      size: 18, color: AppColors.onSurfaceVariant),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
