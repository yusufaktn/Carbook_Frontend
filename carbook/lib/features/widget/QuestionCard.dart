import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/Question/question_model.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final VoidCallback onTap;

  const QuestionCard({Key? key, required this.question, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: const Color(0x33000000),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kullanıcı ve kategori bilgisi
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFF19DB8A),
                    child: Text(
                      '${question.userName.isNotEmpty ? question.userName[0].toUpperCase() : 'U'}',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${question.userName} ${question.userLastName}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF14181B),
                          ),
                        ),
                        Text(
                          question.categoryName,
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
                      color: const Color(0xFF19DB8A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      question.brandName,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF19DB8A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Soru başlığı
              Text(
                question.title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF14181B),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Soru içeriği
              Text(
                question.content,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF57636C),
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Alt kısım - Alt kategori ve ok ikonu
              Row(
                children: [
                  if (question.subBrandCategory.isNotEmpty) ...[
                    Icon(
                      Icons.local_offer_outlined,
                      size: 16,
                      color: const Color(0xFF57636C),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      question.subBrandCategory,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF57636C),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: const Color(0xFF19DB8A),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
