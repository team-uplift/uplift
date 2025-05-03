import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:uplift/components/donor_tag_card.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/models/donor_tag_model.dart';
import 'package:uplift/models/recipient_model.dart';
import '../../constants/constants.dart';

class DonorTagPage extends StatefulWidget {
  final List<Map<String, dynamic>> questionsAnswers;
  final http.Client? httpClient;

  const DonorTagPage({
    super.key,
    required this.questionsAnswers,
    this.httpClient,
  });

  static const baseUrl =
      'http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift';

  @override
  State<DonorTagPage> createState() => _DonorTagPageState();
}

class _DonorTagPageState extends State<DonorTagPage> {
  List<DonorTag> tags = [];
  List<String> selectedTags = [];
  bool isLoading = true;
  late final http.Client _httpClient;

  @override
  void initState() {
    super.initState();
    _httpClient = widget.httpClient ?? http.Client();
    fetchDonorTags();
    print('Received questions answers: ${widget.questionsAnswers}');
  }

  @override
  void dispose() {
    if (widget.httpClient == null) {
      _httpClient.close();
    }
    super.dispose();
  }

  Future<void> fetchDonorTags() async {
    final url =
        Uri.parse('${DonorTagPage.baseUrl}/recipients/tags/random?quantity=10');
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          tags = data.map((tagJson) => DonorTag.fromJson(tagJson)).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        debugPrint(
            '❌ Failed to load donor tags. Status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('❗ Error fetching donor tags: $e');
    }
  }

  void _toggleTag(String tagName) {
    setState(() {
      if (selectedTags.contains(tagName)) {
        selectedTags.remove(tagName);
      } else {
        selectedTags.add(tagName);
      }
    });
  }

  Future<void> _goToNextScreen() async {
    if (selectedTags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one tag')),
      );
      return;
    }

    // Add selected tags to the last dictionary in questions_answers
    final lastIndex = widget.questionsAnswers.length - 1;
    widget.questionsAnswers[lastIndex]['answer'] = selectedTags.join(', ');

    setState(() => isLoading = true);

    try {
      final url =
          Uri.parse('${DonorTagPage.baseUrl}/recipients/matching').replace();

      debugPrint('Requesting URL: $url');

      final response = await _httpClient.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(widget.questionsAnswers),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> recipientsJson = jsonDecode(response.body);
        final recipients =
            recipientsJson.map((json) => Recipient.fromJson(json)).toList();

        if (mounted) {
          context.goNamed(
            '/recipient_list',
            extra: recipients,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to fetch recipients: ${response.statusCode}\n${response.body}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Causes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.baseBlue,
                    // gradient: LinearGradient(
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    //   colors: [
                    //     Theme.of(context).primaryColor,
                    //     Theme.of(context).primaryColor.withOpacity(0.8),
                    //   ],
                    // ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose What Matters to You",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Select the causes you care about to find recipients who need your help",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Tags Grid
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Available Causes",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: tags.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 3 / 2,
                              ),
                              itemBuilder: (context, index) {
                                final tag = tags[index];
                                final isSelected =
                                    selectedTags.contains(tag.tagName);
                                return GestureDetector(
                                  onTap: () => _toggleTag(tag.tagName),
                                  child: DonorTagCard(
                                    tag: tag,
                                    isSelected: isSelected,
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Next Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: StandardButton(
                    title: 'Find Recipients',
                    onPressed: _goToNextScreen,
                  ),
                ),
              ),
            ),
          ),

          // Loading Overlay
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
