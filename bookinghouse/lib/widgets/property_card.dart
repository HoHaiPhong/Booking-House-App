import 'package:flutter/material.dart';
import '../models/property_model.dart';
import 'package:intl/intl.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  String _formatCurrency(double price) {
    if (price >= 1000000000) {
      return "${(price / 1000000000).toStringAsFixed(1)} tỷ";
    } else if (price >= 1000000) {
      return "${(price / 1000000).toStringAsFixed(1)} triệu";
    }
    return NumberFormat.currency(locale: 'vi', symbol: '₫').format(price);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE SECTION
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: property.images.isNotEmpty
                      ? Image.network(
                          property.images[0],
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (c,e,s) => Container(color: Colors.grey[300], height: 180, child: const Icon(Icons.image, size: 50)),
                        )
                      : Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(Icons.home, size: 50, color: Colors.grey),
                        ),
                ),
                // VIP BADGE (Mock)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('VIP Kim Cương', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
                // PHOTO COUNT
                if (property.images.length > 1)
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.photo, color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text('${property.images.length}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  )
              ],
            ),
            
            // CONTENT SECTION
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.name.toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        _formatCurrency(property.price),
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      if (property.area != null) ...[
                        const Text("•", style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 10),
                        Text(
                          "${property.area} m²",
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.address,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  // FOOTER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: property.ownerAvatar != null ? NetworkImage(property.ownerAvatar!) : null,
                            child: property.ownerAvatar == null ? const Icon(Icons.person, size: 14) : null,
                          ),
                          const SizedBox(width: 8),
                          Text(property.ownerName ?? "Môi giới", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red[700],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.phone, size: 14, color: Colors.white),
                                SizedBox(width: 4),
                                Text("09877...", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.favorite_border, color: Colors.grey),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
