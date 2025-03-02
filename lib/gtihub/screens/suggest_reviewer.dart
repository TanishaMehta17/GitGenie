import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gitgenie/common/colors.dart';
import 'package:gitgenie/common/typography.dart';
import 'package:gitgenie/gtihub/service/githubService.dart';

class SuggestReviewer extends StatefulWidget {

  @override
  _SuggestReviewerState createState() => _SuggestReviewerState();
}

class _SuggestReviewerState extends State<SuggestReviewer> {
  final TextEditingController _prNumberController = TextEditingController();
  final TextEditingController _repoOwnerController = TextEditingController();
  final TextEditingController _repoNameController = TextEditingController();
  final GithubService githubService = GithubService();

  String? _reviewer;
  bool _isLoading = false;
  String errorMessage = "";

  Future<void> _fetchReviewer() async {
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
      _reviewer = null;
      errorMessage = "";
    });

    githubService.SuggestReviewer(
      prNumber: prNumber,
      repoOwner: repoOwner,
      repoName: repoName,
      callback: (success, fetchedReviewers, message) {
        print(
            "API Response: success=$success, message=$message, reviewers=$fetchedReviewers");
        setState(() {
          _isLoading = false;
          if (success) {
            _reviewer = fetchedReviewers.isNotEmpty
                ? fetchedReviewers.join(', ')
                : "No reviewer found";
            errorMessage = "";
          } else {
            _reviewer = null;
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
                  _buildSectionTitle("👥 Assigning Reviewers"),
                  _buildDescription(
                      "Assigns reviewers based on past contributions, Ensures fair distribution among team members."),
                  _buildDescription(
                      "Enter details below to get the assigned reviewer for your PR."),
                  _buildInputField("PR Number", _prNumberController),
                  _buildInputField("Repository Owner", _repoOwnerController),
                  _buildInputField("Repository Name", _repoNameController),
                  SizedBox(height: 20),
                  _buildSubmitButton(),
                  SizedBox(height: 20),
                  if (_reviewer != null || errorMessage.isNotEmpty)
                    _buildReviewerSection(),
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
        onPressed: _isLoading ? null : _fetchReviewer,
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _isLoading
            ? CircularProgressIndicator(color: white)
            : Text("Get Reviewer", style: TextStyle(color: primaryColor)),
      ),
    );
  }

  Widget _buildReviewerSection() {
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
          if (_reviewer != null)
            Text("👤 Assigned Reviewer:",
                style: SCRTypography.subHeading.copyWith(color: white)),
          if (_reviewer != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(_reviewer!, style: TextStyle(color: white70)),
            ),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child:
                  Text(errorMessage, style: TextStyle(color: Colors.redAccent)),
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
