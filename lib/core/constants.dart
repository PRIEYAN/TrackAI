import 'package:flutter/material.dart';

class AppConstants {
  static const String baseUrl = 'http://localhost:8000/api'; // Update for production
  // For Android emulator, use: http://10.0.2.2:8000/api
  // For iOS simulator, use: http://localhost:8000/api
  // For physical device, use your computer's IP: http://YOUR_IP:8000/api
  // Or use ngrok: https://your-ngrok-url.ngrok-free.app/api
  
  // Theme Colors - Enhanced Blue Palette
  static const Color primaryColor = Color(0xFF1E3A8A); // Deep Blue
  static const Color primaryColorDark = Color(0xFF1E40AF); // Darker Blue
  static const Color primaryColorLight = Color(0xFF3B82F6); // Bright Blue
  static const Color accentColor = Color(0xFF3B82F6); // Bright Blue
  static const Color accentColorLight = Color(0xFF60A5FA); // Light Blue
  static const Color accentColorDark = Color(0xFF2563EB); // Dark Accent Blue
  static const Color successColor = Color(0xFF10B981); // Emerald
  static const Color errorColor = Color(0xFFEF4444); // Red
  static const Color backgroundColor = Color(0xFFF8FAFC); // Light Blue-Gray
  static const Color surfaceColor = Color(0xFFFFFFFF); // White
  static const Color cardBackground = Color(0xFFFFFFFF); // White
  static const Color textPrimary = Color(0xFF1E293B); // Dark Slate
  static const Color textSecondary = Color(0xFF64748B); // Slate Gray
  static const Color dividerColor = Color(0xFFE2E8F0); // Light Blue Gray
  
  // Blue Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Forwarder Orange Theme
  static const Color forwarderOrange = Color(0xFFFF6B35); // Primary Orange
  static const Color forwarderOrangeLight = Color(0xFFFF8C5A); // Light Orange
  static const Color forwarderOrangeDark = Color(0xFFE55A2B); // Dark Orange
  static const Color forwarderBackground = Color(0xFFFFF8F5); // Light Orange Background

  // Splash Theme Colors
  static const Color leafGreen = Color(0xFF4CAF50);
  static const Color sunflowerYellow = Color(0xFFFFEB3B);
  static const Color obsidianBlack = Color(0xFF1A1A1A);
}


