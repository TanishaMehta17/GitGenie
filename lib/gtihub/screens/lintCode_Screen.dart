import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gitgenie/common/colors.dart';
import 'package:gitgenie/common/typography.dart';
import 'package:gitgenie/gtihub/service/githubService.dart';

class LintcodeScreen extends StatefulWidget {
  @override
  _LintcodeScreenState createState() => _LintcodeScreenState();
}

class _LintcodeScreenState extends State<LintcodeScreen> {
  final TextEditingController _prNumberController = TextEditingController();
  final TextEditingController _repoOwnerController = TextEditingController();
  final TextEditingController _repoNameController = TextEditingController();
  final GithubService githubService = GithubService();

  bool _isLoading = false;
  String errorMessage = "";
  List<String> lintingSummary = [];
  List<String>? errors;
  List<String>? warnings;
  List<String>? suggestions;

  Future<void> _fetchLintingDetails() async {
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
      lintingSummary = [];
      errors = warnings = suggestions = null;
      errorMessage = "";
    });

    githubService.lintCode(
      prNumber: prNumber,
      repoOwner: repoOwner,
      repoName: repoName,
      callback: (success, summary, message, {errors, warnings, suggestions}) {
        setState(() {
          _isLoading = false;
          if (success) {
            lintingSummary = summary;
            this.errors = errors;
            this.warnings = warnings;
            this.suggestions = suggestions;
            errorMessage = "";
          } else {
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
                  _buildSectionTitle("📝 Code Linting"),
                  _buildDescription(
                      "Detects style violations and formatting issues. Ensures the team follows predefined coding standards. Prevents non-compliant code from merging."),
                      _buildDescription(
                      "🔴 Prerequisites for Code Linting\n Your GitHub repository must include a .lint.yml file specifying the linting rules.\nA properly configured ESLint for JavaScript projects.\nBy enforcing linting, GitGenie helps prevent inconsistent or low-quality code from making it into the codebase."),
                  _buildInputField("PR Number", _prNumberController),
                  _buildInputField("Repository Owner", _repoOwnerController),
                  _buildInputField("Repository Name", _repoNameController),
                  SizedBox(height: 20),
                  _buildSubmitButton(),
                  SizedBox(height: 20),
                  if (errorMessage.isNotEmpty) _buildErrorMessage(),
                  if (lintingSummary.isNotEmpty) _buildLintingDetails(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(title, style: SCRTypography.heading1.copyWith(color: white)),
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
        onPressed: _isLoading ? null : _fetchLintingDetails,
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _isLoading
            ? CircularProgressIndicator(color: white)
            : Text("Run Lint Check", style: TextStyle(color: primaryColor)),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(errorMessage, style: TextStyle(color: Colors.redAccent)),
    );
  }

  Widget _buildLintingDetails() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🔍 Linting Details:",
              style: SCRTypography.subHeading.copyWith(color: white)),
          ...lintingSummary.map(
              (detail) => Text("• $detail", style: TextStyle(color: white70))),
          if (errors != null && errors!.isNotEmpty)
            _buildLintingList("❌ Errors", errors!),
          if (warnings != null && warnings!.isNotEmpty)
            _buildLintingList("⚠️ Warnings", warnings!),
          if (suggestions != null && suggestions!.isNotEmpty)
            _buildLintingList("💡 Suggestions", suggestions!),
        ],
      ),
    );
  }

  Widget _buildLintingList(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: SCRTypography.subHeading.copyWith(color: white)),
          ...items
              .map((item) => Text("• $item", style: TextStyle(color: white70))),
        ],
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
