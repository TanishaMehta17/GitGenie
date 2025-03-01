import 'package:flutter/material.dart';
import 'package:gitgenie/common/colors.dart';
import 'package:gitgenie/common/typography.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

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
      body: Container(
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
                    "GitGenie is an AI-driven pull request management tool designed to streamline code review, maintain high-quality standards, and automate key GitHub workflows. Whether you are working solo or in a team, GitGenie helps in ensuring that every PR meets best coding practices before merging."),
                _buildSectionTitle("🚀 Core Features of GitGenie", Icons.star),
                _buildFeatureSection("🔍 Pull Request Analysis", [
                  "Ensures PRs follow best practices.",
                  "Validates commit messages for clarity and structure.",
                  "Identifies updates that might break existing functionality."
                ]),
                _buildFeatureSection(
                    "📝 Code Linting (Requires Configuration)", [
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
                  "Examples: Bug Fix 🐞, Feature 🚀, Security 🔐 etc..."
                ]),
                _buildFeatureSection("👥 Assigning Reviewers", [
                  "Assigns reviewers based on past contributions.",
                  "Ensures fair distribution among team members."
                ]),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: primaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.code), label: "Suggest Code- Fixes"),
          BottomNavigationBarItem(
              icon: Icon(Icons.security), label: "Analyse Security Risks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.group), label: "Assign Reviewers"),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: "Review PRs"),
          BottomNavigationBarItem(
              icon: Icon(Icons.line_style), label: "Lint Code"),
          BottomNavigationBarItem(icon: Icon(Icons.label), label: "Label PRs"),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: white),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              //   textAlign: TextAlign.center,
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
          SizedBox(height: 5),
          ...points.map((point) => Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: Colors.greenAccent, size: 18),
                    SizedBox(width: 6),
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
}
