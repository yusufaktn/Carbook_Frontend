import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../provider/Answer/answer_provider.dart';
import '../widget/AnswerCard.dart';
import '../widget/AddAnswerWidget.dart';
import '../model/Question/question_model.dart';

class QuestionDetailScreen extends StatefulWidget {
  final QuestionModel question;

  const QuestionDetailScreen({Key? key, required this.question})
    : super(key: key);

  @override
  State<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnswerProvider>(
        context,
        listen: false,
      ).loadAnswersByQuestionId(widget.question.questionId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F4F8),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF14181B),
            size: 20,
          ),
        ),
        title: Text(
          'Soru Detayı',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF14181B),
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Paylaş işlemi
              print('Soru paylaşıldı: ${widget.question.questionId}');
            },
            icon: const Icon(
              Icons.share_outlined,
              color: Color(0xFF14181B),
              size: 20,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // Soru Kartı
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: const Color(0x1A000000),
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kullanıcı ve kategori bilgisi
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xFF19DB8A),
                                child: Text(
                                  '${widget.question.userName.isNotEmpty ? widget.question.userName[0].toUpperCase() : 'U'}',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.question.userName} ${widget.question.userLastName}',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF14181B),
                                      ),
                                    ),
                                    Text(
                                      widget.question.categoryName,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: const Color(0xFF57636C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF19DB8A,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  widget.question.brandName,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFF19DB8A),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Soru başlığı
                          Text(
                            widget.question.title,
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF14181B),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Soru içeriği
                          Text(
                            widget.question.content,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: const Color(0xFF14181B),
                              height: 1.5,
                            ),
                          ),

                          if (widget.question.subBrandCategory.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F4F8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_offer_outlined,
                                    size: 16,
                                    color: const Color(0xFF57636C),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    widget.question.subBrandCategory,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: const Color(0xFF57636C),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Cevaplar Bölümü
                  Consumer<AnswerProvider>(
                    builder: (context, answerProvider, child) {
                      if (answerProvider.isLoading) {
                        return Container(
                          margin: const EdgeInsets.all(16),
                          height: 200,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF19DB8A),
                            ),
                          ),
                        );
                      }

                      if (answerProvider.error != null) {
                        return Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red[300],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Cevaplar yüklenirken hata oluştu',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF14181B),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                answerProvider.error!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF57636C),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  answerProvider.loadAnswersByQuestionId(
                                    widget.question.questionId,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF19DB8A),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  'Tekrar Dene',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cevaplar başlığı
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.comment_outlined,
                                  color: const Color(0xFF19DB8A),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Cevaplar (${answerProvider.answers.length})',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF14181B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Cevaplar listesi
                          if (answerProvider.answers.isEmpty)
                            Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.comment_outlined,
                                      size: 48,
                                      color: const Color(0xFF57636C),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Henüz cevap yok',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF14181B),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'İlk cevabı veren siz olun!',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: const Color(0xFF57636C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ...answerProvider.answers
                                .map((answer) => AnswerCard(answer: answer))
                                .toList(),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 100), // AddAnswerWidget için boşluk
                ],
              ),
            ),
          ),

          // Cevap ekleme widget'i
          AddAnswerWidget(questionId: widget.question.questionId),
        ],
      ),
    );
  }
}
