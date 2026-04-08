import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../provider/CategoryProvider.dart';
import '../model/Category/CategoryModel.dart';

class FilterWidget extends StatefulWidget {
  final Function(int? categoryId) onCategoryChanged;
  final Function(String sortBy) onSortChanged;

  const FilterWidget({
    Key? key,
    required this.onCategoryChanged,
    required this.onSortChanged,
  }) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  int? selectedCategoryId;
  String selectedSort = 'newest';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x1A000000),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Kategori Filtreleme
          Row(
            children: [
              Icon(
                Icons.filter_list_rounded,
                color: const Color(0xFF19DB8A),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Kategori:',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF14181B),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        value: selectedCategoryId,
                        hint: Text(
                          'Tüm Kategoriler',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF57636C),
                          ),
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF57636C),
                        ),
                        items: [
                          DropdownMenuItem<int?>(
                            value: null,
                            child: Text(
                              'Tüm Kategoriler',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xFF14181B),
                              ),
                            ),
                          ),
                          ...categoryProvider.categories.map((
                            Categorymodel category,
                          ) {
                            return DropdownMenuItem<int?>(
                              value: category.CategoryId,
                              child: Text(
                                category.CategoryName,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF14181B),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedCategoryId = newValue;
                          });
                          widget.onCategoryChanged(newValue);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Sıralama Filtreleme
          Row(
            children: [
              Icon(
                Icons.sort_rounded,
                color: const Color(0xFF19DB8A),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Sırala:',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF14181B),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    _buildSortButton('newest', 'En Yeni'),
                    const SizedBox(width: 8),
                    _buildSortButton('oldest', 'En Eski'),
                    const SizedBox(width: 8),
                    _buildSortButton('popular', 'Popüler'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton(String value, String label) {
    final bool isSelected = selectedSort == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedSort = value;
          });
          widget.onSortChanged(value);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF19DB8A) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF19DB8A)
                  : const Color(0xFFE5E7EB),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.white : const Color(0xFF57636C),
            ),
          ),
        ),
      ),
    );
  }
}
