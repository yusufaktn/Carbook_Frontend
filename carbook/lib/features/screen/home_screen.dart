import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/CategoryProvider.dart';
import '../provider/Question/question_provider.dart';
import '../widget/CustomAppBar.dart';
import '../widget/SearchBarWidget.dart';
import '../widget/CategoriesSection.dart';
import '../widget/LatestQuestionsSection.dart';
import 'questions_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Uygulama başladığında kategorileri ve son soruları yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
      Provider.of<QuestionProvider>(context, listen: false).loadLastQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF1F4F8),
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QuestionsListScreen(),
              ),
            );
          },
          child: Container(
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
            child: const Align(
              alignment: AlignmentDirectional(0, 0),
              child: Icon(Icons.add_rounded, color: Colors.white, size: 28),
            ),
          ),
        ),
        appBar: const CustomAppBar(),
        body: const SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SearchBarWidget(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: 20),
                      CategoriesSection(),
                      SizedBox(height: 24),
                      LatestQuestionsSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
