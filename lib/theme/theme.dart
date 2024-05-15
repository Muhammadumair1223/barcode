import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFF003473),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  cardColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white.withOpacity(0.2),
    titleTextStyle: GoogleFonts.montserrat(
      fontSize: 20, // Tamaño de la fuente
      fontWeight: FontWeight.w500, // Peso de la fuente
      color: Colors.black, // Color del texto
    ),
    toolbarHeight: 56,
    centerTitle: true,
    // color: Colors.white,
    elevation: 10,
  ),
  textTheme: GoogleFonts.latoTextTheme()
      .apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      )
      .copyWith(
        titleLarge: GoogleFonts.lato(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        headlineSmall: GoogleFonts.lato(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        headlineMedium: GoogleFonts.lato(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        displaySmall: GoogleFonts.lato(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        displayMedium: GoogleFonts.lato(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        displayLarge: GoogleFonts.lato(
          fontSize: 36.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        titleMedium: GoogleFonts.lato(
          fontSize: 16.0,
          color: Colors.black87,
        ),
        titleSmall: GoogleFonts.lato(
          fontSize: 14.0,
          color: Colors.black87,
        ),
        bodyLarge: GoogleFonts.lato(
          fontSize: 16.0,
          color: Colors.black87,
        ),
        bodyMedium: GoogleFonts.lato(
          fontSize: 14.0,
          color: Colors.black87,
        ),
        bodySmall: GoogleFonts.lato(
          fontSize: 12.0,
          color: Colors.black87,
        ),
        labelLarge: GoogleFonts.lato(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        labelSmall: GoogleFonts.lato(
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF003473),
    secondary: Color(0xFFCC003F),
    surface: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black87,
    onError: Colors.white,
  ).copyWith(secondary: const Color(0xFFCC003F)),
);
