// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:colorize/colorize.dart';
import 'package:meta/meta.dart';

export 'package:colorize/colorize.dart' show Styles;

/// True if color should be applied.
///
/// Defaults to autodetecting stdout.
@visibleForTesting
bool useColorForOutput = stdout.supportsAnsiEscapes;

String _colorizeIfAppropriate(String string, Styles color) {
  if (!useColorForOutput) {
    return string;
  }
  return Colorize(string).apply(color).toString();
}

/// Prints [message] in green, if the environment supports color.
void printSuccess(String message) {
  final colorized = Colorize(message)..green();
  print(colorized);
}

/// Prints [message] in yellow, if the environment supports color.
void printWarning(String message) {
  final colorized = Colorize(message)..yellow();
  print(colorized);
}

/// Prints [message] in red, if the environment supports color.
void printError(String message) {
  final colorized = Colorize(message)..red();
  print(colorized);
}

/// Prints [message] in blue, if the environment supports color.
void printInfo(String message) {
  final colorized = Colorize(message)..blue();
  print(colorized);
}

/// Returns [message] with escapes to print it in [color], if the environment
/// supports color.
String colorizeString(String message, Styles color) {
  return _colorizeIfAppropriate(message, color);
}
