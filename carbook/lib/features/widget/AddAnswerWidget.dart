import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../provider/Answer/answer_provider.dart';

class AddAnswerWidget extends StatefulWidget {
  final int questionId;

  const AddAnswerWidget({Key? key, required this.questionId}) : super(key: key);

  @override
  State<AddAnswerWidget> createState() => _AddAnswerWidgetState();
}

class _AddAnswerWidgetState extends State<AddAnswerWidget> {
  final TextEditingController _answerController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void dispose() {
    _answerController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submitAnswer() async {
    if (_answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen cevabınızı yazın', style: GoogleFonts.inter()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final answerProvider = Provider.of<AnswerProvider>(context, listen: false);
    final success = await answerProvider.addAnswer(
      widget.questionId,
      _answerController.text.trim(),
    );

    if (success) {
      _answerController.clear();
      setState(() {
        _isExpanded = false;
      });
      _focusNode.unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cevabınız başarıyla eklendi!',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: const Color(0xFF19DB8A),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            answerProvider.error ?? 'Cevap eklenirken bir hata oluştu',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
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
            Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  color: const Color(0xFF19DB8A),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Cevabınızı yazın',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF14181B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Cevap yazma alanı
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: TextField(
                controller: _answerController,
                focusNode: _focusNode,
                maxLines: _isExpanded ? 6 : 3,
                decoration: InputDecoration(
                  hintText: 'Bu soruya cevabınızı buraya yazabilirsiniz...',
                  hintStyle: GoogleFonts.inter(
                    color: const Color(0xFF57636C),
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: const Color(0xFF19DB8A),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF14181B),
                ),
                onTap: () {
                  setState(() {
                    _isExpanded = true;
                  });
                },
                onChanged: (value) {
                  if (value.isNotEmpty && !_isExpanded) {
                    setState(() {
                      _isExpanded = true;
                    });
                  }
                },
              ),
            ),

            if (_isExpanded) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _answerController.clear();
                        setState(() {
                          _isExpanded = false;
                        });
                        _focusNode.unfocus();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: const Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'İptal',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF57636C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Consumer<AnswerProvider>(
                      builder: (context, answerProvider, child) {
                        return ElevatedButton(
                          onPressed: answerProvider.isAddingAnswer
                              ? null
                              : _submitAnswer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF19DB8A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: answerProvider.isAddingAnswer
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Cevapla',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
