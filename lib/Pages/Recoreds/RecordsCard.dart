import 'package:flutter/material.dart';

class RecordCard extends StatefulWidget {
  final String title;
  final String time;
  final String size;
  final bool isOutdoor;

  const RecordCard({
    super.key,
    required this.title,
    required this.time,
    required this.size,
    this.isOutdoor = false,
  });

  @override
  State<RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
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
                    Image.asset(
                      widget.isOutdoor
                          ? "Assets/images/recording.png"
                          : "Assets/images/recording.png",
                      width: 70,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: 70,
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(0.2), // Adjust fade here
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_circle_fill,
                  color: Color.fromARGB(157, 0, 0, 0), size: 28),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.time,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            widget.size,
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
