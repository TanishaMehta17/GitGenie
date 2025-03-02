import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gitgenie/common/colors.dart';
import 'package:gitgenie/common/typography.dart';
import 'package:gitgenie/gtihub/service/githubService.dart';
import 'package:flutter/animation.dart';

class RiskAnalysisScreen extends StatefulWidget {

  @override
  _RiskAnalysisScreenState createState() => _RiskAnalysisScreenState();
}

class _RiskAnalysisScreenState extends State<RiskAnalysisScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _prNumberController = TextEditingController();
  final TextEditingController _repoOwnerController = TextEditingController();
  final TextEditingController _repoNameController = TextEditingController();
  final GithubService githubService = GithubService();

  bool _isLoading = false;
  double? _riskScore;
  String _explanation = "";
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
  }

  Future<void> _fetchRiskAnalysis() async {
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
      _riskScore = null;
      _explanation = "";
    });

    githubService.riskAnalysis(
      prNumber: prNumber,
      repoOwner: repoOwner,
      repoName: repoName,
      callback: (success, data, message) {
        setState(() {
          _isLoading = false;
          if (success && data.isNotEmpty) {
            double risk = double.tryParse(data[0]) ?? 0.0;
            _riskScore = risk;
            _explanation = data[1];
            _animation = Tween<double>(begin: 0, end: risk).animate(
              CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
            );
            _animationController.forward(from: 0);
          } else {
            _riskScore = null;
            _explanation = message;
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
                  _buildSectionTitle("⚠️ Risk Analysis"),
                  _buildDescription("Scans PRs for security vulnerabilities and warns about potential risks before merging."),
                  _buildInputField("PR Number", _prNumberController),
                  _buildInputField("Repository Owner", _repoOwnerController),
                  _buildInputField("Repository Name", _repoNameController),
                  SizedBox(height: 20),
                  _buildSubmitButton(),
                  if (_isLoading) _buildLoadingIndicator(),
                  if (_riskScore != null) _buildRiskDisplay(),
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
      child: Text(text, style: SCRTypography.subHeading.copyWith(color: white70)),
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
        onPressed: _isLoading ? null : _fetchRiskAnalysis,
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text("Analyze Risk", style: TextStyle(color: primaryColor)),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircularProgressIndicator(color: white),
      ),
    );
  }

  Widget _buildRiskDisplay() {
    return Column(
      children: [
        SizedBox(height: 30),
        Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: CircularProgressIndicator(
                      value: _animation.value / 100,
                      strokeWidth: 10,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                      backgroundColor: Colors.white30,
                    ),
                  ),
                  Text(
                    "${_animation.value.toStringAsFixed(1)}%",
                    style: SCRTypography.heading1.copyWith(color: white),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Text(
          _explanation,
          textAlign: TextAlign.center,
          style: SCRTypography.subHeading.copyWith(color: white70),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _prNumberController.dispose();
    _repoOwnerController.dispose();
    _repoNameController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
