// Copyright (c) 2017, Matthew. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Support for doing something awesome.
///
/// More dartdocs go here.
library tools;

//export 'src/http_headers.dart';
export 'src/a_privilege_set.dart';
export 'package:tools/src/exceptions/not_implemented_exception.dart';
export 'package:tools/src/exceptions/duplicate_item_exception.dart';
export 'package:tools/src/exceptions/invalid_input_exception.dart';
export 'package:tools/src/exceptions/not_found_exception.dart';
export 'package:tools/src/exceptions/unauthorized_exception.dart';
export 'package:tools/src/exceptions/forbidden_exception.dart';
export 'src/diff.dart';
export 'src/http_headers.dart';
export 'src/mime_types.dart';

// TODO: Export any libraries intended for clients of this package.
import 'dart:math';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

const int httpStatusServerNeedsSetup = 555;

/// A [RegExp]-compatible [String] that matches against [String]s that contain ONLY a formatted [Uuid].
const String uuidRegexString = "\^$uuidRegexStringSnippet\$";

/// A [RegExp]-compatible [String] that matches against [String]s that contain a formatted [Uuid].
const String uuidRegexStringSnippet =
    r"[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}";

/// A pre-prepared [RegExp] that matches against [Uuid] [String]s.
final RegExp uuidRegex = new RegExp(uuidRegexString);

const String hexColorRegexString = r"^#[\da-fA-F]{6}$";
final RegExp hexColorRegex = new RegExp(hexColorRegexString);

final path.Context urlPath = new path.Context(style: path.Style.url);

const List<String> reservedRegexChars = const <String>[
  r'\',
  '.',
  '^',
  r'$',
  '*',
  '+',
  '-',
  '?',
  '(',
  ')',
  '[',
  ']',
  '{',
  '}',
  '|'
];

String escapeAll(String input) {
  String output = input;
  reservedRegexChars.forEach((String c) {
    output = output.replaceAll(c, "\\$c");
  });
  return output;
}

/// Takes a hex character only uuid string and formats it with dashes at the appropriate locations.
String formatUuid(String input) {
  final StringBuffer output = new StringBuffer();
  if (input.length < 32) {
    throw new Exception("UUID too short: $input");
  }
  output.write(input.substring(0, 8));
  output.write("-");
  output.write(input.substring(8, 12));
  output.write("-");
  output.write(input.substring(12, 16));
  output.write("-");
  output.write(input.substring(16, 20));
  output.write("-");
  output.write(input.substring(20, 32));
  return output.toString();
}

const String uuidNamespace = "d34f2371-60dc-46d5-abe1-57a53fd03750";
const String uniqueKeySomeday = "uniqueKey";

/// Generate a brand new uuid.
String generateUuid() => new Uuid().v4();

/// Converts an enum value to a string of the post-type name.
String getEnumValueString(dynamic enumValue) =>
    enumValue.toString().substring(enumValue.toString().indexOf('.') + 1);

/// Returns a [bool] indicating whether the provided [String] is formatted as a [Uuid]
bool isUuid(String uuid) {
  return uuidRegex.hasMatch(uuid);
}

/// Checks if the [map] has a key matching the provided [key], then checks if the key's value is [null], only whitespace, or blank. Returns a [bool] indicating the status.
bool keyExistsAndHasValue(Map<dynamic, dynamic> map, String key) {
  if (!map.containsKey(key)) {
    return false;
  }
  if (map[key] == null) {
    return false;
  }
  return !isNullOrWhitespace(map[key]);
}

/// Returns a [String] containing the validation error message for the specified input [String], or an empty [String] if the input is valid for use as a [RegExp].
String validateRegularExpression(String input) {
  try {
    final RegExp test = new RegExp(input);
    test.hasMatch("Fishmobabywhirlamagig");
    return "";
  } on FormatException catch (e) {
    return e.message;
  }
}

/// This matches the w3 spec for use with type="email" input fields, and that's good enough for us.
final RegExp _emailRegex = new RegExp(
    r"^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");

/// Checks if the [email] specified matches whe w3 spec regexp for email input fields, which is close enough to validating it as an e-mail address.
bool isValidEmail(String email) {
  if (email == null) throw new ArgumentError.notNull("email");
  return _emailRegex.hasMatch(email);
}

/// Checks if the [input] String is [null], only whitespace, or blank, returning a [true] if any of these conditions are met. Returns a [false] otherwise.
bool isNullOrWhitespace(String input) {
  if (input == null) {
    return true;
  }

  if (input.trim() == "") {
    return true;
  }

  return false;
}

bool isNotNullOrWhitespace(String input) {
  return !isNullOrWhitespace(input);
}

Future<Null> wait({int milliseconds: 100}) {
  final Completer<Null> completer = new Completer<Null>();
  new Timer(new Duration(milliseconds: milliseconds), () {
    completer.complete();
  });
  return completer.future;
}

/// Calculates the size of a rectangle that fits within the confines of another
/// rectangle the size of the dimensions described by [outer] with the same
/// aspect ratio as the rectangle described by [inner].
Point fitWithin(Point inner, Point outer) {
  final double outerRatio = outer.x / outer.y;
  final double innerRatio = inner.x / inner.y;

  if (outerRatio < innerRatio) {
    final num x = outer.x;
    final num y = inner.y * (outer.x / inner.x);
    return new Point(x, y);
  } else if (outerRatio > innerRatio) {
    final num y = outer.y;
    final num x = inner.x * (outer.y / inner.y);
    return new Point(x, y);
  } else {
    return new Point(outer.x, outer.y);
  }
}
