import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:your_project_name/services/api_service.dart'; // Replace with your actual API service file
import 'package:your_project_name/widgets/tag_input.dart'; // Replace with your actual TagInput widget

class AddEditNotes extends StatefulWidget {
  final VoidCallback onClose;
  final Map<String, dynamic>? noteData;
  final String type;
  final VoidCallback getAllNotes;

  AddEditNotes({
    required this.onClose,
    this.noteData,
    required this.type,
    required this.getAllNotes,
  });

  @override
  _AddEditNotesState createState() => _AddEditNotesState();
}

class _AddEditNotesState extends State<AddEditNotes> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  List<String> tags = [];
  String? error;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.noteData?['title'] ?? "");
    contentController = TextEditingController(text: widget.noteData?['content'] ?? "");
    tags = widget.noteData?['tags']?.cast<String>() ?? [];
  }

  Future<void> editNote() async {
    final noteId = widget.noteData?['_id'];
    
    try {
      final response = await ApiService.editNote(
        noteId: noteId,
        title: titleController.text,
        content: contentController.text,
        tags: tags,
      );

      if (!response['success']) {
        setState(() {
          error = response['message'];
        });
        Fluttertoast.showToast(msg: response['message']);
        return;
      }

      Fluttertoast.showToast(msg: response['message']);
      widget.getAllNotes();
      widget.onClose();
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
      setState(() {
        this.error = error.toString();
      });
    }
  }

  Future<void> addNewNote() async {
    try {
      final response = await ApiService.addNote(
        title: titleController.text,
        content: contentController.text,
        tags: tags,
      );

      if (!response['success']) {
        setState(() {
          error = response['message'];
        });
        Fluttertoast.showToast(msg: response['message']);
        return;
      }

      Fluttertoast.showToast(msg: response['message']);
      widget.getAllNotes();
      widget.onClose();
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
      setState(() {
        this.error = error.toString();
      });
    }
  }

  void handleAddNote() {
    if (titleController.text.isEmpty) {
      setState(() {
        error = "Please enter the title";
      });
      return;
    }

    if (contentController.text.isEmpty) {
      setState(() {
        error = "Please enter the content";
      });
      return;
    }

    setState(() {
      error = null;
    });

    if (widget.type == "edit") {
      editNote();
    } else {
      addNewNote();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -10,
          top: -10,
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.grey),
            onPressed: widget.onClose,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title',
                style: TextStyle(color: Colors.red, textTransform: TextTransform.uppercase),
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'ENTER YOUR NOTE TITLE',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(height: 16),
              Text(
                'Content',
                style: TextStyle(color: Colors.red, textTransform: TextTransform.uppercase),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  hintText: 'ENTER YOUR DESCRIPTION',
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 16),
              Text(
                '# tags',
                style: TextStyle(color: Colors.red, textTransform: TextTransform.uppercase),
              ),
              TagInput(
                tags: tags,
                setTags: (newTags) {
                  setState(() {
                    tags = newTags;
                  });
                },
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    error!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: handleAddNote,
                child: Text(widget.type.toUpperCase() == "EDIT" ? "UPDATE" : "ADD"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
