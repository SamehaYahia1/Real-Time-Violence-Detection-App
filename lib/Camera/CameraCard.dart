import 'package:flutter/material.dart';

class CameraCard extends StatelessWidget {
  final String cameraName;
  final String location;
  final bool isOnline;
  final VoidCallback onTap;
  final String? thumbnailUrl;

  const CameraCard({
    required this.cameraName,
    required this.location,
    required this.isOnline,
    required this.onTap,
    this.thumbnailUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      shadowColor: Colors.black54,
      clipBehavior: Clip.antiAlias, // Ensures rounded clipping
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildThumbnailSection(),
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailSection() {
    return Stack(
      children: [
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            image: DecorationImage(
              image: thumbnailUrl != null
                  ? NetworkImage(thumbnailUrl!)
                  : const AssetImage('Assets/images/image.jpeg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white
                    .withOpacity(0.8), // Adjust opacity here (0.0 to 1.0)
                BlendMode
                    .dstATop, // You can experiment with different blend modes
              ),
            ),
          ),
        ),

        // Gradient overlay
        if (thumbnailUrl != null)
          Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        Positioned(
          top: 10,
          right: 10,
          child: _buildStatusIndicator(),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOnline
              ? [
                  const Color(0xFF305D9B),
                  const Color(0xFF0D1A4A),
                ]
              : [
                  Colors.grey.shade800,
                  Colors.grey.shade900,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  cameraName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              // const Icon(
              //   Icons.chevron_right,
              //   color: Colors.white70,
              // ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.location_pin,
                size: 18,
                color: Colors.red,
              ),
              const SizedBox(width: 1),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildConnectionStatus(),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isOnline
            ? Colors.greenAccent.withOpacity(0.8)
            : Colors.redAccent.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnline ? Icons.circle : Icons.circle_outlined,
            size: 10,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            isOnline ? 'LIVE' : 'OFFLINE',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOnline ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isOnline ? 'Streaming now' : 'Connection lost',
          style: TextStyle(
            fontSize: 12,
            color: isOnline ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
