import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_html/flutter_html.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  String htmlContent = '';

  @override
  void initState() {
    super.initState();
    loadHtml();
  }

  bool isLoading = true;

  Future<void> loadHtml() async {
    try {
    final String fileHtml = await rootBundle.loadString('assets/privacy-policy.html');
    setState(() {
      htmlContent = fileHtml;
      isLoading = false;
    });
  } catch (e) {
    debugPrint('Error loading HTML: $e');
    setState(() {
      htmlContent = '<h1>Error loading privacy policy.</h1>';
      isLoading = false;
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white
            ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Privacy Policy')
      ),
      body: htmlContent.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Html(data: htmlContent),
            ),
    );
  }
}