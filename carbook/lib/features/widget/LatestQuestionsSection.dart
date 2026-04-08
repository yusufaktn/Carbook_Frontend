import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:carbook/features/provider/Question/question_provider.dart';
import 'package:carbook/features/model/Question/question_model.dart';
import '../screen/questions_list_screen.dart';
import '../screen/question_detail_screen.dart';

class LatestQuestionsSection extends StatefulWidget {
  const LatestQuestionsSection({Key? key}) : super(key: key);

  @override
  State<LatestQuestionsSection> createState() => _LatestQuestionsSectionState();
}

class _LatestQuestionsSectionState extends State<LatestQuestionsSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionProvider>(
      builder: (context, questionProvider, child) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Son Sorulanlar',
                    style: GoogleFonts.readexPro(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF14181B),
                      fontSize: 22,
                      letterSpacing: 0.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuestionsListScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Tümü',
                      style: GoogleFonts.readexPro(
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF19DB8A),
                        fontSize: 14,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: _buildQuestionsList(questionProvider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuestionsList(QuestionProvider questionProvider) {
    if (questionProvider.error != null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              color: Color(0x0D000000),
              offset: Offset(0.0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 8),
            Text(
              questionProvider.error!,
              textAlign: TextAlign.center,
              style: GoogleFonts.readexPro(color: Colors.red, fontSize: 14),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                questionProvider.clearError();
                questionProvider.loadLastQuestions();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF19DB8A),
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Tekrar Dene',
                style: GoogleFonts.readexPro(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
    }

    if (questionProvider.isLoading) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              color: Color(0x0D000000),
              offset: Offset(0.0, 1),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFF19DB8A)),
        ),
      );
    }

    if (questionProvider.lastQuestions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              color: Color(0x0D000000),
              offset: Offset(0.0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            const Icon(Icons.quiz_outlined, color: Colors.grey, size: 48),
            const SizedBox(height: 8),
            Text(
              'Henüz soru bulunmuyor',
              style: GoogleFonts.readexPro(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: questionProvider.lastQuestions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final question = questionProvider.lastQuestions[index];
        return _QuestionItem(
          question: question,
          categoryColor: _getCategoryColor(index),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuestionDetailScreen(question: question),
              ),
            );
          },
        );
      },
    );
  }

  Color _getCategoryColor(int index) {
    final colors = [
      const Color(0xFF4285F4),
      const Color(0xFF34A853),
      const Color(0xFFEA4335),
      const Color(0xFFFBBC04),
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }
}

class _QuestionItem extends StatelessWidget {
  final QuestionModel question;
  final Color categoryColor;
  final VoidCallback onTap;

  const _QuestionItem({
    Key? key,
    required this.question,
    required this.categoryColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              color: Color(0x0D000000),
              offset: Offset(0.0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Container(
                      color: const Color(0xFF19DB8A),
                      child: Center(
                        child: Text(
                          question.userName.isNotEmpty
                              ? question.userName[0].toUpperCase()
                              : 'U',
                          style: GoogleFonts.readexPro(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${question.userName} ${question.userLastName}',
                              style: GoogleFonts.readexPro(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF14181B),
                                fontSize: 14,
                                letterSpacing: 0.0,
                              ),
                            ),
                            Text(
                              'Şimdi',
                              style: GoogleFonts.readexPro(
                                color: const Color(0xFF57636C),
                                fontSize: 12,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '@${question.userName.toLowerCase()}',
                          style: GoogleFonts.readexPro(
                            color: const Color(0xFF57636C),
                            fontSize: 12,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                question.title,
                style: GoogleFonts.readexPro(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF14181B),
                  fontSize: 16,
                  letterSpacing: 0.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                question.content,
                style: GoogleFonts.readexPro(
                  color: const Color(0xFF14181B),
                  fontSize: 14,
                  letterSpacing: 0.0,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      question.categoryName,
                      style: GoogleFonts.readexPro(
                        color: categoryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: const Color(0xFF57636C),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '0',
                            style: GoogleFonts.readexPro(
                              color: const Color(0xFF57636C),
                              fontSize: 12,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: const Color(0xFF57636C),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '0',
                            style: GoogleFonts.readexPro(
                              color: const Color(0xFF57636C),
                              fontSize: 12,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ],
                      ),
                    ],
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
