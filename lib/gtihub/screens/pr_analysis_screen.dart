import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gitgenie/common/colors.dart';
import 'package:gitgenie/common/typography.dart';
import 'package:gitgenie/gtihub/service/githubService.dart';

class PrAnalysisScreen extends StatefulWidget {
  @override
  _PrAnalysisScreenState createState() => _PrAnalysisScreenState();
}

class _PrAnalysisScreenState extends State<PrAnalysisScreen> {
final TextEditingController _prNumberController =
      TextEditingController(text: "13");
  final TextEditingController _repoOwnerController =
      TextEditingController(text: "TanishaMehta17");
  final TextEditingController _repoNameController =
      TextEditingController(text: "Real-Time-Collaboration-Application");
  final GithubService githubService = GithubService();

  Map<String, dynamic>? analysisData;
  bool _isLoading = false;
  String errorMessage = "";

  Future<void> _fetchCodeFixSuggestions() async {
    final String prNumber = _prNumberController.text.trim();
    final String repoOwner = _repoOwnerController.text.trim();
    final String repoName = _repoNameController.text.trim();

    if (prNumber.isEmpty || repoOwner.isEmpty || repoName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please input all the valid details")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      analysisData = null;
      errorMessage = "";
    });

    githubService.prAnalysis(
      prNumber: prNumber,
      repoOwner: repoOwner,
      repoName: repoName,
      callback: (success, data, message) {
        setState(() {
          _isLoading = false;
          if (success) {
            analysisData = data;
            errorMessage = "";
          } else {
            analysisData = null;
            errorMessage = message;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("🔍 Pull Request Analysis"),
                  _buildDescription("Ensures PRs follow best practices.Validates commit messages for clarity and structure.Identifies updates that might break existing functionality."),
                  _buildDescription("Enter details below to analyze your PR."),
                  _buildInputField("PR Number", _prNumberController),
                  _buildInputField("Repository Owner", _repoOwnerController),
                  _buildInputField("Repository Name", _repoNameController),
                  SizedBox(height: 20),
                  _buildSubmitButton(),
                  SizedBox(height: 20),
                  if (analysisData != null) _buildAnalysisSection(),
                  if (errorMessage.isNotEmpty)
                    Text(errorMessage, style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
Widget _buildAnalysisSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildSectionTitle("📄 PR Details"),
      _buildInfoItem("📌 Title", analysisData?["PR Title"] ?? "N/A"),
      _buildInfoItem("👤 Author", analysisData?["Author"] ?? "N/A"),
      _buildInfoItem("📝 Changed Files", analysisData?["Changed Files"] ?? "0"),
      _buildInfoItem("➕ Additions", analysisData?["Additions"] ?? "0"),
      _buildInfoItem("➖ Deletions", analysisData?["Deletions"] ?? "0"),
      _buildInfoItem("🔄 Total Changes", analysisData?["Total Changes"] ?? "0"),

      _buildSectionTitle("🧐 Analysis"),
      _buildInfoItem("🔒 Security Findings", 
        analysisData?["Security Findings"]?.toString() ?? "None"),
      _buildInfoItem("⚡ Quality Issues", 
        analysisData?["Quality Issues"]?.toString() ?? "None"),
      _buildInfoItem("🏆 Best Practices", 
        analysisData?["Best Practices"]?.toString() ?? "None"),
      _buildInfoItem("📈 Improvement Suggestions", 
        analysisData?["Improvement Suggestions"]?.toString() ?? "None"),
    ],
  );
}


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(title, style: SCRTypography.heading1.copyWith(color: white)),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: SCRTypography.subHeading.copyWith(color: white)),
          Text(value, style: TextStyle(color: white70)),
        ],
      ),
    );
  }

  Widget _buildDescription(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child:
          Text(text, style: SCRTypography.subHeading.copyWith(color: white70)),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: white70),
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _isLoading ? null : _fetchCodeFixSuggestions,
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _isLoading
            ? CircularProgressIndicator(color: white)
            : Text("Get Suggestions", style: TextStyle(color: primaryColor)),
      ),
    );
  }

  @override
  void dispose() {
    _prNumberController.dispose();
    _repoOwnerController.dispose();
    _repoNameController.dispose();
    super.dispose();
  }
}
