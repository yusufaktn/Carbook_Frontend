import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:carbook/features/provider/CategoryProvider.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({Key? key}) : super(key: key);

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  @override
  void initState() {
    super.initState();
    // Widget yüklendiğinde kategorileri getir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        // Error state
        if (categoryProvider.error != null) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Text(
                  'Hızlı Erişim',
                  style: GoogleFonts.readexPro(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF14181B),
                    fontSize: 22,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Column(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      categoryProvider.error!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.readexPro(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        categoryProvider.clearError();
                        categoryProvider.loadCategories();
                      },
                      child: Text('Tekrar Dene'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        // Loading state
        if (categoryProvider.isLoading) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Text(
                  'Hızlı Erişim',
                  style: GoogleFonts.readexPro(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF14181B),
                    fontSize: 22,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }

        // Empty state
        if (categoryProvider.categories.isEmpty) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Text(
                  'Hızlı Erişim',
                  style: GoogleFonts.readexPro(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF14181B),
                    fontSize: 22,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.category_outlined,
                        color: Colors.grey,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Henüz kategori bulunmuyor',
                        style: GoogleFonts.readexPro(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        // Success state - kategoriler varsa göster
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: Text(
                'Hızlı Erişim',
                style: GoogleFonts.readexPro(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF14181B),
                  fontSize: 22,
                  letterSpacing: 0.0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.5, // Daha küçük kartlar için oran
                ),
                itemCount: categoryProvider.categories.length.clamp(0, 3),
                itemBuilder: (context, index) {
                  final category = categoryProvider.categories[index];
                  return _buildCategoryCard(
                    context,
                    title: category.CategoryName,
                    imageUrl: category.imageUrl,
                    color: _getColorForCategory(index),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Index'e göre renk döndürür
  Color _getColorForCategory(int index) {
    final colors = [
      const Color(0xFF4285F4), // Mavi
      const Color(0xFF34A853), // Yeşil
      const Color(0xFFEA4335), // Kırmızı
      const Color(0xFFFBBC04), // Sarı
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    String? imageUrl,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        // Kategori tıklanma işlemi - ileride kategori detay sayfasına yönlendirme
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title kategorisi seçildi'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x1A000000),
              offset: Offset(0.0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            // Background image (şeffaf)
            if (imageUrl != null && imageUrl.isNotEmpty)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.3), // %30 şeffaflık
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(); // Hata durumunda boş
                    },
                  ),
                ),
              ),
            // Kategori adı
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.readexPro(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 10,
                      letterSpacing: 0.0,
                      height: 1.1,
                      shadows: [
                        const Shadow(
                          offset: Offset(0.5, 0.5),
                          blurRadius: 2,
                          color: Color(0x80000000),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
