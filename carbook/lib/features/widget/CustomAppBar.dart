import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screen/profile_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF1F4F8),
      automaticallyImplyLeading: false,
      title: Text(
        'Ustam',
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF19DB8A),
          fontSize: 24,
          letterSpacing: 0.0,
        ),
      ),
      actions: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: IconButton(
                onPressed: () {
                  print('Arama iconuna basıldı');
                },
                icon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF14181B),
                  size: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: GestureDetector(
                onTap: () {
                  // Profil sayfasına yönlendir - Demo için userId: 1
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(userId: 1),
                    ),
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1592092227004-aa4517de4f80?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NTgwMjQ5MjF8&ixlib=rb-4.1.0&q=80&w=1080',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
      centerTitle: false,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
