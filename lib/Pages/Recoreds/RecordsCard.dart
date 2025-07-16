import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Notifactions/url_convert.dart';

class RecordCard extends StatelessWidget {
  final String title;
  final String time;
  final String size;
  final bool isOutdoor;
  final String thumbnailUrl;

  const RecordCard({
    super.key,
    required this.title,
    required this.time,
    required this.size,
    this.isOutdoor = false,
    required this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(181, 144, 163, 181),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    thumbnailUrl.isNotEmpty
                        ? Image.network(
                            fixMinioUrl(thumbnailUrl),
                            width: 70,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.black12,
                              width: 70,
                              height: 50,
                              child: const Icon(Icons.image_not_supported),
                            ),
                          )
                        : Image.asset(
                            'Assets/images/recording.png',
                            width: 70,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                    Container(
                      width: 70,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )
                  ],
                ),
              ),
              const Icon(
                Icons.play_circle_fill,
                color: Color.fromARGB(157, 0, 0, 0),
                size: 28,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            size,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
