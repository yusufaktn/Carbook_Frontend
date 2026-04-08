import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../provider/Question/question_provider.dart';
import '../provider/CategoryProvider.dart';
import '../widget/CustomAppBar.dart';
import '../widget/FilterWidget.dart';
import '../widget/QuestionCard.dart';
import '../model/Question/question_model.dart';
import 'question_detail_screen.dart';

class QuestionsListScreen extends StatefulWidget {
  const QuestionsListScreen({Key? key}) : super(key: key);

  @override
  State<QuestionsListScreen> createState() => _QuestionsListScreenState();
}

class _QuestionsListScreenState extends State<QuestionsListScreen> {
  final ScrollController _scrollController = ScrollController();
  List<QuestionModel> filteredQuestions = [];
  int? selectedCategoryId;
  String selectedSort = 'newest';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuestionProvider>(context, listen: false).loadAllQuestions();
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _applyFilters(List<QuestionModel> questions) {
    setState(() {
      filteredQuestions = List.from(questions);

      // Kategori filtresi
      if (selectedCategoryId != null) {
        filteredQuestions = filteredQuestions
            .where((question) => question.categoryId == selectedCategoryId)
            .toList();
      }

      // Sıralama
      switch (selectedSort) {
        case 'newest':
          filteredQuestions.sort(
            (a, b) => b.questionId.compareTo(a.questionId),
          );
          break;
        case 'oldest':
          filteredQuestions.sort(
            (a, b) => a.questionId.compareTo(b.questionId),
          );
          break;
        case 'popular':
          // Şu an için questionId'ye göre sıralama, ileride popularity field'i eklenebilir
          filteredQuestions.sort(
            (a, b) => b.questionId.compareTo(a.questionId),
          );
          break;
      }
    });
  }

  void _onCategoryChanged(int? categoryId) {
    selectedCategoryId = categoryId;
    final questionProvider = Provider.of<QuestionProvider>(
      context,
      listen: false,
    );
    _applyFilters(questionProvider.questions);
  }

  void _onSortChanged(String sortBy) {
    selectedSort = sortBy;
    final questionProvider = Provider.of<QuestionProvider>(
      context,
      listen: false,
    );
    _applyFilters(questionProvider.questions);
  }

  void _navigateToQuestionDetail(QuestionModel question) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionDetailScreen(question: question),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          // Filter Widget
          FilterWidget(
            onCategoryChanged: _onCategoryChanged,
            onSortChanged: _onSortChanged,
          ),

          // Questions List
          Expanded(
            child: Consumer<QuestionProvider>(
              builder: (context, questionProvider, child) {
                if (questionProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF19DB8A)),
                  );
                }

                if (questionProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Bir hata oluştu',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF14181B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            questionProvider.error!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF57636C),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            questionProvider.loadAllQuestions();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF19DB8A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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

                // Filtrelenmiş soruları güncelle
                if (questionProvider.questions.isNotEmpty &&
                    filteredQuestions.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _applyFilters(questionProvider.questions);
                  });
                } else if (questionProvider.questions != filteredQuestions &&
                    selectedCategoryId == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _applyFilters(questionProvider.questions);
                  });
                }

                if (filteredQuestions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.quiz_outlined,
                          size: 64,
                          color: const Color(0xFF57636C),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Henüz soru bulunmuyor',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF14181B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'İlk soruyu sormak için + butonuna tıklayın',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF57636C),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 8, bottom: 100),
                  itemCount: filteredQuestions.length,
                  itemBuilder: (context, index) {
                    final question = filteredQuestions[index];
                    return QuestionCard(
                      question: question,
                      onTap: () => _navigateToQuestionDetail(question),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: Color(0xFF19DB8A),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Color(0x33000000),
              offset: Offset(0.0, 4),
            ),
          ],
          shape: BoxShape.circle,
        ),
        child: InkWell(
          onTap: () {
            // Yeni soru ekleme sayfasına yönlendir
            print('Yeni soru ekle');
          },
          borderRadius: BorderRadius.circular(32),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
