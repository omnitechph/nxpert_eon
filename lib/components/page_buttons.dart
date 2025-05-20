import 'package:flutter/material.dart';

class PageButtons extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageSelected;

  const PageButtons({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    int startPage = currentPage - 1;
    int endPage = currentPage + 1;
    if (totalPages <= 3) {
      startPage = 1;
      endPage = totalPages;
    } else {
      if (currentPage <= 1) {
        startPage = 1;
        endPage = 3;
      } else if (currentPage >= totalPages) {
        startPage = totalPages - 2;
        endPage = totalPages;
      }
      startPage = startPage.clamp(1, totalPages);
      endPage = endPage.clamp(1, totalPages);
    }

    return Row(
      children: List<Widget>.generate(endPage - startPage + 1, (int index) {
        final int pageNumber = startPage + index;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: currentPage == pageNumber ? const Color(0xFF337AB7) : Colors.white,
            foregroundColor: currentPage == pageNumber ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            side: BorderSide(
              color: currentPage == pageNumber ? const Color(0xFF337AB7) : const Color(0xFFDDDDDD),
            ),
            minimumSize: const Size(45, 36),
            padding: EdgeInsets.zero,
          ),
          onPressed: () => onPageSelected(pageNumber),
          child: Text('$pageNumber'),
        );
      }),
    );
  }
}
