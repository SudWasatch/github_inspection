
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:github_inspection/providers/providers.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserData {
  final Map<String, dynamic> data;

  UserData({required this.data});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(data: json);
  }
}

Future<String?> getIpAddress(BuildContext context) async {
  try {
    final response = await http.get(Uri.parse('https://api.ipify.org'));
    if (response.statusCode == 200) {
      var add = response.body;
      // ignore: use_build_context_synchronously
      Provider.of<IpProvider>(context, listen: false).setIpAddress(add);
      return add;
    } else {
      debugPrint('Failed to get IP address: ${response.statusCode}');
      return null;
    }
  } on SocketException catch (e) {
    debugPrint("Exception: $e");
    return "Please check your internet connection";
  } catch (e) {
    debugPrint('Error getting IP address: $e');
    return null;
  }
}

class DropdownItem {
  final String id, name;
  const DropdownItem({required this.id, required this.name});
}
