import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final DateTime date;
  final String content;
  final List<String> tags;
  final bool isPinned;
  final VoidCallback onPinNote;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  NoteCard({
    required this.title,
    required this.date,
    required this.content,
    required this.tags,
    required this.isPinned,
    required this.onPinNote,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      DateFormat('d MMM yyyy').format(date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    color: isPinned ? Color(0xFF2B85FF) : Colors.grey,
                  ),
                  onPressed: onPinNote,
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              content.length > 60 ? '${content.substring(0, 60)}...' : content,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: 4,
                  children: tags.map((tag) => Text(
                    '#$tag',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  )).toList(),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.green.shade600,
                      ),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red.shade500,
                      ),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
