import 'package:flutter/material.dart';
import 'package:gitgenie/common/colors.dart';
import 'package:gitgenie/common/typography.dart';
import 'package:gitgenie/gtihub/screens/codeFix_Screen.dart';
import 'package:gitgenie/gtihub/screens/labelPR.dart';
import 'package:gitgenie/gtihub/screens/lintCode_Screen.dart';
import 'package:gitgenie/gtihub/screens/riskAnalysis_Screen.dart';
import 'package:gitgenie/gtihub/screens/suggest_reviewer.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.asset(
                'assets/images/github.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          "GitGenie",
          style: SCRTypography.heading.copyWith(color: white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHomeContent(),
          SuggestCodeFixScreen(),
          SuggestReviewer(),
          RiskAnalysisScreen(),
          LabelPrScreen(),
          LintcodeScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        onTap: (index) {
          setState(() {
            _tabController.index = index;
          });
        },
        selectedItemColor: primaryColor,
        unselectedItemColor: secondaryColor,
        backgroundColor: primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.code), label: 'Code-Fix'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Reviewer'),
          BottomNavigationBarItem(
              icon: Icon(Icons.security), label: 'Risk-Analysis'),
          BottomNavigationBarItem(icon: Icon(Icons.label), label: 'Label PR'),
          BottomNavigationBarItem(
              icon: Icon(Icons.line_style), label: 'Lint Code'),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(
                  "GitGenie - AI-Powered PR Management", Icons.auto_awesome),
              _buildDescription(
                  "GitGenie is an AI-driven pull request management tool designed to streamline code review, maintain high-quality standards, and automate key GitHub workflows."),
              _buildSectionTitle("🚀 Core Features of GitGenie", Icons.star),
              _buildFeatureSection("🔍 Pull Request Analysis", [
                "Ensures PRs follow best practices.",
                "Validates commit messages for clarity and structure.",
                "Identifies updates that might break existing functionality."
              ]),
              _buildFeatureSection("📝 Code Linting (Requires Configuration)", [
                "Detects style violations and formatting issues.",
                "Ensures the team follows predefined coding standards.",
                "Prevents non-compliant code from merging."
              ]),
              _buildFeatureSection("🔴 Prerequisites for Code Linting", [
                "Your GitHub repository must include a `.lint.yml` file specifying the linting rules.",
                "A properly configured ESLint for JavaScript projects.",
                "By enforcing linting, GitGenie helps prevent inconsistent or low-quality code from making it into the codebase."
              ]),
              _buildFeatureSection("⚠️ Risk Analysis", [
                "Scans PRs for security vulnerabilities.",
                "Analyzes code changes for breaking issues.",
                "Warns about potential risks before merging."
              ]),
              _buildFeatureSection("💡 Automated Code Fix Suggestions", [
                "Suggests optimizations and alternative implementations.",
                "Highlights redundant code blocks for removal."
              ]),
              _buildFeatureSection("🏷️ PR Labeling", [
                "Automatically labels pull requests based on content.",
                "Examples: Bug Fix 🐞, Feature 🚀, Security 🔐, Enhancement ✨, Documentation 📄, Performance ⚡, Configuration 🛠️ etc..."
              ]),
              _buildFeatureSection("👥 Assigning Reviewers", [
                "Assigns reviewers based on past contributions.",
                "Ensures fair distribution among team members."
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: SCRTypography.heading.copyWith(color: white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: SCRTypography.subHeading.copyWith(color: white70),
      ),
    );
  }

  Widget _buildFeatureSection(String title, List<String> points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: SCRTypography.subHeading
                .copyWith(color: white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          ...points.map((point) => Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: requirementColor, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        point,
                        style:
                            SCRTypography.subHeading.copyWith(color: white70),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildPlaceholderContent(String text) {
    return Center(
      child: Text(
        text,
        style:
            TextStyle(color: white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
