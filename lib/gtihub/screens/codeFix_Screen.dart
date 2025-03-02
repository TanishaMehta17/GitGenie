import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gitgenie/common/colors.dart';
import 'package:gitgenie/common/typography.dart';
import 'package:gitgenie/gtihub/service/githubService.dart';

class SuggestCodeFixScreen extends StatefulWidget {
  static const String routeName = '/suggest-code-fix';

  @override
  _SuggestCodeFixScreenState createState() => _SuggestCodeFixScreenState();
}

class _SuggestCodeFixScreenState extends State<SuggestCodeFixScreen> {
  final TextEditingController _prNumberController = TextEditingController();
  final TextEditingController _repoOwnerController = TextEditingController();
  final TextEditingController _repoNameController = TextEditingController();
  final GithubService githubService = GithubService();

  String? _fixes;
  String? _explanation;
  bool _isLoading = false;

  List<String> fixes = [];
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
      _fixes = null;
      _explanation = null;
      errorMessage = "";
    });

    print("Calling API...");

    githubService.suggestCodeFix(
      prNumber: prNumber,
      repoOwner: repoOwner,
      repoName: repoName,
      callback: (success, fetchedFixes, message) {
        print(
            "API Response: success=$success, message=$message, fixes=$fetchedFixes");
        setState(() {
          _isLoading = false;
          if (success) {
            _fixes = fetchedFixes.join("\n");
            errorMessage = "";
          } else {
            _fixes = null;
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
        // Ensures full height
        child: Container(
          height: MediaQuery.of(context).size.height, // Full emulator height
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(), // Improves scroll behavior
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("🛠️ AI-Powered Code Fix Suggestions"),
                  _buildDescription(
                      "Suggests optimizations and alternative implementations,Highlights redundant code blocks for removal."),
                  _buildDescription(
                      "Enter details below to get AI-driven code fixes for your PR."),
                  _buildInputField("PR Number", _prNumberController),
                  _buildInputField("Repository Owner", _repoOwnerController),
                  _buildInputField("Repository Name", _repoNameController),
                  SizedBox(height: 20),
                  _buildSubmitButton(),
                  SizedBox(height: 20),
                  if (_fixes != null || _explanation != null)
                    _buildFixesSection(),
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

  Widget _buildFixesSection() {
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
          if (_fixes != null)
            Text("🔧 Fixes:",
                style: SCRTypography.subHeading.copyWith(color: white)),
          if (_fixes != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(_fixes!, style: TextStyle(color: white70)),
            ),
          if (_explanation != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text("📝 Explanation:",
                  style: SCRTypography.subHeading.copyWith(color: white)),
            ),
          if (_explanation != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(_explanation!, style: TextStyle(color: white70)),
            ),
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
