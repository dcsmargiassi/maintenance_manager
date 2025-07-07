import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_html/flutter_html.dart';

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({super.key});

  @override
  State<TermsOfServicePage> createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  String htmlContent = '';

  @override
  void initState() {
    super.initState();
    loadHtml();
  }

  Future<void> loadHtml() async {
    try {
      final String fileHtml = await rootBundle.loadString('assets/terms-of-service.html');
      setState(() {
        htmlContent = fileHtml;
      });
    } catch (e) {
      setState(() {
        htmlContent = '<h1>Error loading Terms of Service</h1>';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: htmlContent.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(child: Html(data: htmlContent)),
    );
  }
}