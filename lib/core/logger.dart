// Blue text

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
//
//

void logInfo(msg) {
  String jsonData = '';
  try {
    // Check if the msg is a Uri and handle it separately
    if (msg is Uri) {
      jsonData = msg.toString(); // Convert Uri to String
    } else {
      // Attempt to encode it as JSON
      jsonData = jsonEncode(msg);
    }
  } catch (e) {
    // If encoding fails, fall back to using the msg's string representation
    jsonData = msg.toString();
  }

  // Log the message only in debug mode
  if (kDebugMode) {
    log('\x1B[34m$jsonData\x1B[0m'); // Logs the message in blue
  }
}

// Green text
void logSuccess(msg) {
  String? jsonData;
  try {
    jsonData = jsonEncode(msg);
  } catch (e) {
    jsonData = msg.toString();
  }
  if (kDebugMode) {
    log('\x1B[32m$jsonData\x1B[0m');
  }
}

// Yellow text
void logWarning(msg) {
  String? jsonData;
  try {
    jsonData = jsonEncode(msg);
  } catch (e) {
    jsonData = msg.toString();
  }
  if (kDebugMode) {
    log('\x1B[33m$jsonData\x1B[0m');
  }
}

// Red text
void logError(msg) {
  String? jsonData;
  try {
    jsonData = jsonEncode(msg);
  } catch (e) {
    jsonData = msg.toString();
  }
  if (kDebugMode) {
    log('\x1B[31m$jsonData\x1B[0m');
  }
}
