
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gitgenie/common/global_varibale.dart';
typedef CallBack = void Function(bool success, List<String> fixes, String message);
typedef CallBack1 = void Function(
  bool success,
  List<String> labels,
  String message, {
  List<String>? errors,
  List<String>? warnings,
  List<String>? suggestions,
});


class GithubService {
  Future<void> suggestCodeFix({
    required String prNumber,
    required String repoOwner,
    required String repoName,
    required CallBack callback,
  }) async {
    final url = Uri.parse('$uri/review/suggest-code-fixes');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'owner': repoOwner,
          'repo': repoName,
          'pull_number': prNumber,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == true) {
          if (data['fixes'] is Map<String, dynamic>) {
            List<String> fixes = (data['fixes'] as Map<String, dynamic>).values.map((e) => e.toString()).toList();
            callback(true, fixes, "Fixes fetched successfully.");
          } else if (data['fixes'] is List) {
            List<String> fixes = List<String>.from(data['fixes']);
            callback(true, fixes, "Fixes fetched successfully.");
          } else {
            callback(false, [], "Unexpected response format for fixes.");
          }
        } else {
          callback(false, [], "Error: ${data['message'] ?? 'Unexpected response'}");
        }
      } else {
        callback(false, [], "Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print(" Exception: $e");
      callback(false, [], "Failed to connect: $e");
    }
  }

  Future<void> SuggestReviewer({
    required String prNumber,
    required String repoOwner,
    required String repoName,
    required CallBack callback,
  }) async {
    final url = Uri.parse('$uri/review/assign-reviewer');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'owner': repoOwner,
          'repoName': repoName,
          'prNumber': prNumber,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == true && data['assignedReviewer'] != null) {
          Map<String, dynamic> assignedReviewer = data['assignedReviewer'];
          if (assignedReviewer['success'] == true && assignedReviewer.containsKey('reviewer')) {
            String reviewer = assignedReviewer['reviewer'];
            callback(true, [reviewer], "Reviewer assigned successfully.");
          } else {
            callback(false, [], "Reviewer assignment failed or not available.");
          }
        } else {
          callback(false, [], "Error: ${data['message'] ?? 'Unexpected response'}");
        }
      } else {
        callback(false, [], "Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print(" Exception: $e");
      callback(false, [], "Failed to connect: $e");
    }
  }

  Future<void> riskAnalysis({
  required String prNumber,
  required String repoOwner,
  required String repoName,
  required CallBack callback,
}) async {
  final url = Uri.parse('$uri/review/analyze-risk');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'owner': repoOwner,
        'repo': repoName,
        'prNumber': prNumber,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data['success'] == true && data.containsKey('riskScore')) {
        Map<String, dynamic> riskData = data['riskScore'];
        if (riskData.containsKey('riskScore') && riskData.containsKey('explanation')) {
          double riskScore = riskData['riskScore'];
          String explanation = riskData['explanation'];
          callback(true, [riskScore.toString(), explanation], "Risk analysis successful.");
          return;
        }
      }
      callback(false, [], "Risk data not available or incomplete.");
    } else {
      callback(false, [], "Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("Exception: $e");
    callback(false, [], "Failed to connect: $e");
  }
}

 Future<void> labelPr({ 
  required String prNumber,
  required String repoOwner,
  required String repoName,
  required CallBack callback,
}) async {
  final url = Uri.parse('$uri/review/auto-label-pr');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'owner': repoOwner,
        'repoName': repoName,
        'prNumber': prNumber,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data['success'] == true && data.containsKey('label')) {
        String label = data['label'];
        callback(true, [label], "Label assigned successfully.");
        return;
      }
      callback(false, [], "Label not available in response.");
    } else {
      callback(false, [], "Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("Exception: $e");
    callback(false, [], "Failed to connect: $e");
  }
}


Future<void> lintCode({
  required String prNumber,
  required String repoOwner,
  required String repoName,
  required CallBack1 callback,
}) async {
  final url = Uri.parse('$uri/review/lint-code');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'owner': repoOwner,
        'repo': repoName,
        'prNumber': prNumber,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data['success'] == true && data.containsKey('lintingDetails')) {
        var details = data['lintingDetails'];

        // Convert linting summary map to a list of string descriptions
        List<String> lintingSummary = [
          "Status: ${details['status'] ?? 'Unknown'}",
          "Run Number: ${details['runNumber'] ?? 'N/A'}",
          "Branch: ${details['branch'] ?? 'N/A'}",
          "Commit SHA: ${details['commitSHA'] ?? 'N/A'}",
          "Commit Message: ${details['commitMessage'] ?? 'N/A'}",
          "Triggered By: ${details['triggeredBy'] ?? 'N/A'}",
          "Run Started At: ${details['runStartedAt'] ?? 'N/A'}",
          "Run Completed At: ${details['runCompletedAt'] ?? 'N/A'}",
          "Conclusion: ${details['conclusion'] ?? 'Unknown'}",
          "Action Run URL: ${details['actionRunURL'] ?? 'N/A'}",
          "Lint Workflow URL: ${details['lintWorkflowURL'] ?? 'N/A'}",
          "Repository URL: ${details['repositoryURL'] ?? 'N/A'}",
        ];

        // Extract optional lists for errors, warnings, and suggestions
        List<String>? errors = (details['errors'] as List?)?.map((e) => e.toString()).toList();
        List<String>? warnings = (details['warnings'] as List?)?.map((e) => e.toString()).toList();
        List<String>? suggestions = (details['suggestions'] as List?)?.map((e) => e.toString()).toList();

        callback(true, lintingSummary, "Linting details retrieved successfully.",
          errors: errors, warnings: warnings, suggestions: suggestions);
        return;
      }
      callback(false, [], "Linting details not available in response.");
    } else {
      callback(false, [], "Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("Exception: $e");
    callback(false, [], "Failed to connect: $e");
  }
}




}
