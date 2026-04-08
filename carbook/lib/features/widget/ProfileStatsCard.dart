import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileStatsCard extends StatelessWidget {
  final int questionsCount;
  final int answersCount;

  const ProfileStatsCard({
    super.key,
    required this.questionsCount,
    required this.answersCount,
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.question_answer_outlined,
                label: 'Sorular',
                value: questionsCount.toString(),
                color: const Color(0xFF19DB8A),
              ),
              Container(
                width: 1,
                height: 50,
                color: const Color(0xFFE0E3E7),
              ),
              _buildStatItem(
                icon: Icons.chat_bubble_outline,
                label: 'Cevaplar',
                value: answersCount.toString(),
                color: const Color(0xFF4B39EF),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF14181B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.readexPro(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: const Color(0xFF57636C),
          ),
        ),
      ],
    );
  }
}
