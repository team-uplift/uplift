import 'package:flutter/material.dart';

class TopicModule extends StatelessWidget {
  final String topic;
  final String description;
  final String imageURL;
  const TopicModule({
    required this.topic,
    required this.description,
    required this.imageURL,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(10)),
      height: 80,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600]
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10)),
              child: Image.network(
                height: double.infinity,
                imageURL,
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
}
