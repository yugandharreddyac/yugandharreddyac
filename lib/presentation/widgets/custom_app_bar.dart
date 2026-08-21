import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.showBackButton = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 70 : 60);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      elevation: 0,
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.home, (route) => false);
                    }
                  },
                )
              : null),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: theme.appBarTheme.titleTextStyle,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.brightness == Brightness.light
                    ? AppColors.textSecondaryLight
                    : AppColors.textSecondaryDark,
              ),
            ),
          ],
        ],
      ),
      actions: actions,
    );
  }
}
