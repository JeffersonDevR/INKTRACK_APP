import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:InkTrack/core/theme/app_theme.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? AppTheme.darkCard : Colors.grey.shade300,
      highlightColor: isDark ? AppTheme.darkSurface : Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SkeletonLoader(height: 24, width: 200),
            SizedBox(height: 12),
            SkeletonLoader(height: 16),
            SizedBox(height: 8),
            SkeletonLoader(height: 16, width: 150),
          ],
        ),
      ),
    );
  }
}

class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: const SkeletonLoader(width: 48, height: 48, borderRadius: 24),
        title: const SkeletonLoader(height: 20, width: 120),
        subtitle: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: SkeletonLoader(height: 14, width: 80),
        ),
      ),
    );
  }
}

class SkeletonText extends StatelessWidget {
  final int lines;
  final double lineHeight;

  const SkeletonText({super.key, this.lines = 3, this.lineHeight = 16});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        lines,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index < lines - 1 ? 8 : 0),
          child: SkeletonLoader(
            height: lineHeight,
            width: index == lines - 1 ? 100 : double.infinity,
          ),
        ),
      ),
    );
  }
}
