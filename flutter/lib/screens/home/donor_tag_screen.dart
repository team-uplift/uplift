import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:uplift/components/donor_tag_card.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/models/donor_tag_model.dart';

class DonorTagPage extends StatefulWidget {
  const DonorTagPage({super.key});

  static const baseUrl =
      'http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift';

  @override
  State<DonorTagPage> createState() => _DonorTagPageState();
}

class _DonorTagPageState extends State<DonorTagPage> {
  List<DonorTag> tags = [];
  List<String> selectedTags = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDonorTags();
  }

  Future<void> fetchDonorTags() async {
    final url =
        Uri.parse('${DonorTagPage.baseUrl}/recipients/tags/random?quantity=10');
    try {
      final response = await http.get(url);
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

  void _goToNextScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("Next Screen")),
          body:
              Center(child: Text("Selected Tags: ${selectedTags.join(', ')}")),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Tags')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
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
                        final isSelected = selectedTags.contains(tag.tagName);
                        return GestureDetector(
                          onTap: () => _toggleTag(tag.tagName),
                          child: DonorTagCard(
                            tag: tag,
                            isSelected: isSelected,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                        width: double.infinity,
                        child: StandardButton(
                          title: 'NEXT',
                          onPressed: () {
                            context.goNamed('/recipient_list');
                          },
                        )),
                  ),
                )
              ],
            ),
    );
  }
}
