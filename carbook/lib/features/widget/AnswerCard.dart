import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/Answer/answer_model.dart';

class AnswerCard extends StatelessWidget {
  final AnswerModel answer;

  const AnswerCard({Key? key, required this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: const Color(0x1A000000),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kullanıcı bilgisi ve tarih
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF4B39EF),
                  backgroundImage:
                      answer.profileImageUrl != null &&
                          answer.profileImageUrl!.isNotEmpty
                      ? NetworkImage(answer.profileImageUrl!)
                      : null,
                  onBackgroundImageError: (exception, stackTrace) {
                    // Hata durumunda varsayılan avatar göster
                    print('Profile image load error: $exception');
                  },
                  child:
                      answer.profileImageUrl == null ||
                          answer.profileImageUrl!.isEmpty
                      ? Text(
                          '${answer.userName.isNotEmpty ? answer.userName[0].toUpperCase() : 'U'}',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${answer.userName} ${answer.userLastName}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF14181B),
                        ),
                      ),
                      Text(
                        'Cevap #${answer.answerId}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF57636C),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B39EF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Cevap',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF4B39EF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Cevap içeriği
            Text(
              answer.content,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF14181B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),

            // Alt kısım - Beğeni ve paylaş butonları
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Beğeni işlemi
                    print('Cevap beğenildi: ${answer.answerId}');
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_up_outlined,
                        size: 16,
                        color: const Color(0xFF57636C),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Beğen',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF57636C),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: () {
                    // Paylaş işlemi
                    print('Cevap paylaşıldı: ${answer.answerId}');
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.share_outlined,
                        size: 16,
                        color: const Color(0xFF57636C),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Paylaş',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF57636C),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  '#${answer.answerId}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF57636C),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
