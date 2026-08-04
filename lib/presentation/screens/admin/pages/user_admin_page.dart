import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/user_model.dart';
import '../../../providers/admin_provider.dart';

class UserAdminPage extends StatefulWidget {
  const UserAdminPage({super.key});

  @override
  State<UserAdminPage> createState() => _UserAdminPageState();
}

class _UserAdminPageState extends State<UserAdminPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<AdminProvider>().fetchUsers();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmPromoteAdmin(UserModel user) async {
    final newRole = user.isAdmin ? 'student' : 'admin';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(user.isAdmin ? 'Revoke Admin Role?' : 'Promote to Administrator?'),
        content: Text('Are you sure you want to change role for "${user.email}" to "$newRole"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: user.isAdmin ? Colors.orangeAccent : const Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            child: Text(user.isAdmin ? 'Revoke' : 'Promote'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final adminProvider = context.read<AdminProvider>();
      await adminProvider.updateUserRole(user.uid, newRole);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User role updated to "$newRole".')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final adminProvider = context.watch<AdminProvider>();

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    const royalBlue = Color(0xFF2563EB);
    const emeraldGreen = Color(0xFF10B981);

    final users = adminProvider.users;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          '👥 User & Permissions Management',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: textPrimary),
        ),
        backgroundColor: cardColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => adminProvider.fetchUsers(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Metrics Header
          Container(
            padding: const EdgeInsets.all(16),
            color: cardColor,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (query) => adminProvider.setUserSearchQuery(query),
                  decoration: InputDecoration(
                    hintText: 'Search users by name, email or role...',
                    prefixIcon: const Icon(Icons.search_rounded, color: royalBlue),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              adminProvider.setUserSearchQuery('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? AppColors.surfaceDark : const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: borderColor),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // User List
          Expanded(
            child: adminProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : users.isEmpty
                    ? Center(
                        child: Text('No users match search criteria.', style: GoogleFonts.inter(color: textSubtitle)),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: users.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final lastLogin = DateFormat('MMM d, yyyy').format(user.lastLoginAt);
                          final displayName = (user.displayName != null && user.displayName!.isNotEmpty)
                              ? user.displayName!
                              : (user.email ?? 'Student User');

                          return Container(
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderColor),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: user.isAdmin ? royalBlue.withAlpha(20) : emeraldGreen.withAlpha(20),
                                child: Icon(
                                  user.isAdmin ? Icons.admin_panel_settings_rounded : Icons.person_rounded,
                                  color: user.isAdmin ? royalBlue : emeraldGreen,
                                ),
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      displayName,
                                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimary),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: (user.isAdmin ? royalBlue : emeraldGreen).withAlpha(20),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      user.role.toUpperCase(),
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: user.isAdmin ? royalBlue : emeraldGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                '${user.email} • Last Active: $lastLogin',
                                style: GoogleFonts.inter(fontSize: 12, color: textSubtitle),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  user.isAdmin ? Icons.shield_outlined : Icons.verified_user_outlined,
                                  color: user.isAdmin ? Colors.orangeAccent : royalBlue,
                                ),
                                tooltip: user.isAdmin ? 'Revoke Admin Role' : 'Promote to Admin',
                                onPressed: () => _confirmPromoteAdmin(user),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
