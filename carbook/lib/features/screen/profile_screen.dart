import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../provider/User/user_provider.dart';
import '../provider/Question/question_provider.dart';
import '../widget/ProfileHeader.dart';
import '../widget/ProfileInfoCard.dart';
import '../widget/ProfileStatsCard.dart';
import '../widget/ProfileActionButtons.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;

  const ProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false)
          .loadCurrentUser(widget.userId);
      Provider.of<QuestionProvider>(context, listen: false)
          .loadAllQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F4F8),
        automaticallyImplyLeading: true,
        title: Text(
          'Profil',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF14181B),
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF14181B)),
            onPressed: () {
              _showEditProfileDialog(context);
            },
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF19DB8A),
              ),
            );
          }

          if (userProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Color(0xFF57636C),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bir hata oluştu',
                    style: GoogleFonts.readexPro(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF14181B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userProvider.error!,
                    style: GoogleFonts.readexPro(
                      fontSize: 14,
                      color: const Color(0xFF57636C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      userProvider.loadCurrentUser(widget.userId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF19DB8A),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Tekrar Dene',
                      style: GoogleFonts.readexPro(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final user = userProvider.currentUser;
          if (user == null) {
            return const Center(child: Text('Kullanıcı bulunamadı'));
          }

          // Kullanıcının sorularını hesapla
          final userQuestions = Provider.of<QuestionProvider>(context)
              .questions
              .where((q) => q.userId == user.userId)
              .toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Profil Header (Avatar ve İsim)
                ProfileHeader(user: user),
                
                const SizedBox(height: 24),
                
                // İstatistikler
                ProfileStatsCard(
                  questionsCount: userQuestions.length,
                  answersCount: 0, // API'den gelebilir
                ),
                
                const SizedBox(height: 16),
                
                // Profil Bilgileri
                ProfileInfoCard(user: user),
                
                const SizedBox(height: 16),
                
                // Aksiyon Butonları
                ProfileActionButtons(
                  onEditProfile: () => _showEditProfileDialog(context),
                  onChangePassword: () => _showChangePasswordDialog(context),
                  onLogout: () => _showLogoutDialog(context),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.currentUser;
    
    if (user == null) return;

    final nameController = TextEditingController(text: user.userName);
    final lastNameController = TextEditingController(text: user.userLastName);
    final emailController = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Profili Düzenle',
            style: GoogleFonts.readexPro(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF14181B),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Ad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF19DB8A)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Soyad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF19DB8A)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'E-posta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF19DB8A)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'İptal',
                style: GoogleFonts.readexPro(
                  color: const Color(0xFF57636C),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedUser = user.copyWith(
                  userName: nameController.text,
                  userLastName: lastNameController.text,
                  email: emailController.text,
                );
                
                final success = await userProvider.updateUserProfile(updatedUser);
                
                if (context.mounted) {
                  Navigator.of(context).pop();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Profil başarıyla güncellendi'
                            : 'Profil güncellenemedi',
                      ),
                      backgroundColor:
                          success ? const Color(0xFF19DB8A) : Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF19DB8A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Kaydet',
                style: GoogleFonts.readexPro(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Şifre Değiştir',
            style: GoogleFonts.readexPro(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF14181B),
            ),
          ),
          content: Text(
            'Şifre değiştirme özelliği yakında eklenecek.',
            style: GoogleFonts.readexPro(
              fontSize: 14,
              color: const Color(0xFF57636C),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Tamam',
                style: GoogleFonts.readexPro(
                  color: const Color(0xFF19DB8A),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Çıkış Yap',
            style: GoogleFonts.readexPro(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF14181B),
            ),
          ),
          content: Text(
            'Çıkış yapmak istediğinize emin misiniz?',
            style: GoogleFonts.readexPro(
              fontSize: 14,
              color: const Color(0xFF57636C),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'İptal',
                style: GoogleFonts.readexPro(
                  color: const Color(0xFF57636C),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Çıkış işlemleri burada yapılır
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Profil sayfasından çık
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Çıkış Yap',
                style: GoogleFonts.readexPro(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
