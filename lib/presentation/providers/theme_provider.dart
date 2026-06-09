import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Theme mode: light or dark
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

// High contrast accessibility modifier
final highContrastProvider = StateProvider<bool>((ref) => false);

// Text size scaling factor for low-vision accessibility
final textScaleProvider = StateProvider<double>((ref) => 1.0);
