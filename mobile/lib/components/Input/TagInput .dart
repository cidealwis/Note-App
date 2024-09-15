import 'package:flutter/material.dart';

class TagInput extends StatefulWidget {
  final List<String> tags;
  final Function(List<String>) setTags;

  TagInput({
    required this.tags,
    required this.setTags,
  });

  @override
  _TagInputState createState() => _TagInputState();
}

class _TagInputState extends State<TagInput> {
  final TextEditingController _controller = TextEditingController();

  void _addNewTag() {
    final tag = _controller.text.trim();
    if (tag.isNotEmpty) {
      setState(() {
        widget.setTags([...widget.tags, tag]);
        _controller.clear();
      });
    }
  }

  void _handleKeyDown(RawKeyEvent event) {
    if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      _addNewTag();
    }
  }

  void _handleRemoveTag(String tagToRemove) {
    setState(() {
      widget.setTags(widget.tags.where((tag) => tag != tagToRemove).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.tags.isNotEmpty)
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: widget.tags.map((tag) {
              return Chip(
                label: Text('# $tag'),
                deleteIcon: Icon(Icons.close, size: 18, color: Colors.red),
                onDeleted: () => _handleRemoveTag(tag),
                backgroundColor: Colors.grey.shade100,
                labelStyle: TextStyle(
                  color: Colors.black87,
                ),
              );
            }).toList(),
          ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Add Tags',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onSubmitted: (_) => _addNewTag(),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: _addNewTag,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue.shade700),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.blue.shade700,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
