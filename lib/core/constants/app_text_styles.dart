import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings
  static TextStyle get h1 => GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary);

  static TextStyle get h2 => GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary);

  static TextStyle get h3 => GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary);

  static TextStyle get h4 => GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.textPrimary);

  // Body text
  static TextStyle get bodyLarge => GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textPrimary);

  static TextStyle get bodyMedium => GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textPrimary);

  static TextStyle get bodySmall => GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textSecondary);

  // Button text
  static TextStyle get buttonLarge => GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white);

  static TextStyle get buttonMedium => GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white);

  static TextStyle get buttonSmall => GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white);

  // Caption and overline
  static TextStyle get caption => GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textSecondary);

  static TextStyle get overline => GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textSecondary, letterSpacing: 1.5);

  // Price text
  static TextStyle get price => GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary);

  static TextStyle get priceSmall => GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary);

  // Search text
  static TextStyle get searchHint => GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textHint);

  static TextStyle get searchText => GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textPrimary);
}
