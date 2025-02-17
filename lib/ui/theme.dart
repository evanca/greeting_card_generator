import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greeting_card_generator_sandbox/ui/palette.dart';

class AppTheme {
  static ThemeData themeOf(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Palette.primaryButton,
      ),
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: GoogleFonts.inter(
            textStyle: Theme.of(context).textTheme.bodyMedium,
            color: Palette.labelText),
        hintStyle: GoogleFonts.inter(
            textStyle: Theme.of(context).textTheme.bodyMedium,
            color: Palette.hintText),
        fillColor: Palette.inputFill,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        alignLabelWithHint: true,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: Palette.secondaryButton,
        inactiveTrackColor: Palette.inactiveButton,
        year2023: false, // Use slider UI from Flutter 3.29
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        year2023: false, // Use progress indicator UI from Flutter 3.29
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.primaryButton,
          foregroundColor: Palette.background,
          minimumSize: const Size(double.infinity, 50),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.titleMedium,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          iconColor: Colors.white,
        ),
      ),
    );
  }

  static BoxDecoration get gradientDecoration => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Palette.gradientStart, Palette.gradientEnd],
        ),
      );

  static BoxDecoration get cardDecoration => BoxDecoration(
        color: Palette.background,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Palette.shadowColor,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      );

  static BoxDecoration get heroImageDecoration => BoxDecoration(
        color: Palette.heroImageBackground,
        borderRadius: BorderRadius.circular(20),
      );

  static BoxDecoration get underTextDecoration =>
      const BoxDecoration(color: Palette.cardOverlay);
}
