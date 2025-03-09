import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gitgenie/common/global_varibale.dart';

typedef CallBack = void Function(
    bool success, List<String> fixes, String message);
typedef CallBack1 = void Function(
  bool success,
  List<String> labels,
  String message, {
  List<String>? errors,
  List<String>? warnings,
  List<String>? suggestions,
});

typedef CallBack2 = void Function(bool success, dynamic data, String message);

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
            List<String> fixes = (data['fixes'] as Map<String, dynamic>)
                .values
                .map((e) => e.toString())
                .toList();
            callback(true, fixes, "Fixes fetched successfully.");
          } else if (data['fixes'] is List) {
            List<String> fixes = List<String>.from(data['fixes']);
            callback(true, fixes, "Fixes fetched successfully.");
          } else {
            callback(false, [], "Unexpected response format for fixes.");
          }
        } else {
          callback(
              false, [], "Error: ${data['message'] ?? 'Unexpected response'}");
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
          if (assignedReviewer['success'] == true &&
              assignedReviewer.containsKey('reviewer')) {
            String reviewer = assignedReviewer['reviewer'];
            callback(true, [reviewer], "Reviewer assigned successfully.");
          } else {
            callback(false, [], "Reviewer assignment failed or not available.");
          }
        } else {
          callback(
              false, [], "Error: ${data['message'] ?? 'Unexpected response'}");
        }
      } else {
        callback(false, [], "Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print(" Exception: $e");
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

        if (data['success'] == true && data.containsKey('logs')) {
          var logs = data['logs'];

          // Convert linting summary map to a list of string descriptions
          List<String> lintingSummary = [
            "Status: ${logs['status'] ?? 'Unknown'}",
            "Run Number: ${logs['run_number'] ?? 'N/A'}",
            "Branch: ${logs['head_branch'] ?? 'N/A'}",
            "Commit SHA: ${logs['head_sha'] ?? 'N/A'}",
            "Commit Message: ${logs['head_commit']?['message'] ?? 'N/A'}",
            "Triggered By: ${logs['triggering_actor']?['login'] ?? 'N/A'}",
            "Run Started At: ${logs['run_started_at'] ?? 'N/A'}",
            "Updated At: ${logs['updated_at'] ?? 'N/A'}",
            "Conclusion: ${logs['conclusion'] ?? 'Unknown'}",
            "Workflow Run URL: ${logs['html_url'] ?? 'N/A'}",
            "Logs URL: ${logs['logs_url'] ?? 'N/A'}",
            "Jobs URL: ${logs['jobs_url'] ?? 'N/A'}",
          ];

          // Extract optional lists for errors, warnings, and suggestions if available
          List<String>? errors =
              (logs['errors'] as List?)?.map((e) => e.toString()).toList();
          List<String>? warnings =
              (logs['warnings'] as List?)?.map((e) => e.toString()).toList();
          List<String>? suggestions =
              (logs['suggestions'] as List?)?.map((e) => e.toString()).toList();

          callback(
            true,
            lintingSummary,
            "Linting details retrieved successfully.",
            errors: errors,
            warnings: warnings,
            suggestions: suggestions,
          );
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

  Future<void> prAnalysis({
    required String prNumber,
    required String repoOwner,
    required String repoName,
    required CallBack2 callback,
  }) async {
    final url = Uri.parse('$uri/review/analyze-pr');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'repoOwner': repoOwner,
          'repoName': repoName,
          'prNumber': prNumber,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == true) {
          Map<String, dynamic> result = {
            "PR Title": data['prTitle'] ?? "N/A",
            "Author": data['author'] ?? "N/A",
            "Changed Files": data['changedFiles']?.toString() ?? "0",
            "Additions": data['additions']?.toString() ?? "0",
            "Deletions": data['deletions']?.toString() ?? "0",
            "Total Changes": data['totalChanges']?.toString() ?? "0",
            "Diff Summary": data['diffSummary'] ?? "N/A",
            "Security Findings":
                data['analysis']?['securityFindings']?.toString() ?? "None",
            "Quality Issues":
                data['analysis']?['qualityIssues']?.toString() ?? "None",
            "Best Practices":
                data['analysis']?['bestPractices']?.toString() ?? "None",
            "Improvement Suggestions":
                data['analysis']?['improvementSuggestions']?.toString() ??
                    "None",
          };

          callback(true, result, "PR Analysis fetched successfully.");
        } else {
          callback(
              false, {}, "Error: ${data['message'] ?? 'Unexpected response'}");
        }
      } else {
        callback(false, {}, "Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
      callback(false, {}, "Failed to connect: $e");
    }
  }


  Future<void> riskAnalysis({
  required String prNumber,
  required String repoOwner,
  required String repoName,
  required Function(bool, List<String>, String) callback,
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

      if (data['success'] == true && data.containsKey('riskAnalysis')) {
        Map<String, dynamic> riskData = data['riskAnalysis']; // Fix here

        if (riskData.containsKey('riskScore') &&
            riskData.containsKey('explanation')) {
         double riskScore = (riskData['riskScore'] as num).toDouble();

          String explanation = riskData['explanation'];

          callback(true, [riskScore.toString(), explanation], "Risk analysis successful.");
          return;
        }
      }
   
      callback(false, [], "Risk data not available or incomplete.");
    } else {
      
      callback(false, [], "Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e, stacktrace) {
    callback(false, [], "Failed to connect: $e");
  }
}


}
