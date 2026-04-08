import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileActionButtons extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;
  final VoidCallback onLogout;

  const ProfileActionButtons({
    super.key,
    required this.onEditProfile,
    required this.onChangePassword,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildActionButton(
              icon: Icons.edit_outlined,
              label: 'Profili Düzenle',
              onTap: onEditProfile,
              iconColor: const Color(0xFF19DB8A),
            ),
            const Divider(height: 1),
            _buildActionButton(
              icon: Icons.lock_outline,
              label: 'Şifre Değiştir',
              onTap: onChangePassword,
              iconColor: const Color(0xFF4B39EF),
            ),
            const Divider(height: 1),
            _buildActionButton(
              icon: Icons.logout,
              label: 'Çıkış Yap',
              onTap: onLogout,
              iconColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.readexPro(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF14181B),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF57636C),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
