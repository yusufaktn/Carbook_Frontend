import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
      child: SizedBox(
        width: double.infinity,
        child: TextFormField(
          controller: _textController,
          focusNode: _textFieldFocusNode,
          obscureText: false,
          decoration: InputDecoration(
            hintText: 'Soru Arayın, trend, kategori',
            hintStyle: GoogleFonts.readexPro(
              fontWeight: FontWeight.normal,
              color: const Color(0xFF57636C),
              fontSize: 14,
              letterSpacing: 0.0,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFE0E3E7), width: 1),
              borderRadius: BorderRadius.circular(24),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF19DB8A), width: 1),
              borderRadius: BorderRadius.circular(24),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0x00000000), width: 1),
              borderRadius: BorderRadius.circular(24),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0x00000000), width: 1),
              borderRadius: BorderRadius.circular(24),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsetsDirectional.fromSTEB(
              20,
              12,
              20,
              12,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF57636C),
              size: 20,
            ),
          ),
          style: GoogleFonts.readexPro(
            fontWeight: FontWeight.normal,
            color: const Color(0xFF14181B),
            fontSize: 14,
            letterSpacing: 0.0,
          ),
        ),
      ),
    );
  }
}
