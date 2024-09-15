import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:your_project_name/services/api_service.dart'; // Replace with your actual API service file
import 'package:your_project_name/widgets/note_card.dart'; // Replace with your actual NoteCard widget
import 'package:your_project_name/widgets/empty_card.dart'; // Replace with your actual EmptyCard widget
import 'package:your_project_name/widgets/add_edit_notes.dart'; // Replace with your actual AddEditNotes widget
import 'package:your_project_name/widgets/navbar.dart'; // Replace with your actual Navbar widget

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Map<String, dynamic>> _userInfoFuture;
  List<Map<String, dynamic>> allNotes = [];
  bool isSearch = false;
  bool isAddEditModalOpen = false;
  Map<String, dynamic>? noteData;
  String modalType = "add";

  @override
  void initState() {
    super.initState();
    _userInfoFuture = ApiService.getUserInfo();
    getAllNotes();
  }

  Future<void> getAllNotes() async {
    try {
      final response = await ApiService.getAllNotes();
      if (response['success'] == false) {
        print(response);
        return;
      }
      setState(() {
        allNotes = List<Map<String, dynamic>>.from(response['notes']);
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> handleEdit(Map<String, dynamic> noteDetails) async {
    setState(() {
      noteData = noteDetails;
      modalType = "edit";
      isAddEditModalOpen = true;
    });
  }

  Future<void> deleteNote(String noteId) async {
    try {
      final response = await ApiService.deleteNote(noteId);
      if (response['success'] == false) {
        Fluttertoast.showToast(msg: response['message']);
        return;
      }
      Fluttertoast.showToast(msg: response['message']);
      getAllNotes();
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  Future<void> onSearchNote(String query) async {
    try {
      final response = await ApiService.searchNotes(query);
      if (response['success'] == false) {
        Fluttertoast.showToast(msg: response['message']);
        return;
      }
      setState(() {
        isSearch = true;
        allNotes = List<Map<String, dynamic>>.from(response['notes']);
      });
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  void handleClearSearch() {
    setState(() {
      isSearch = false;
    });
    getAllNotes();
  }

  Future<void> updateIsPinned(String noteId, bool isPinned) async {
    try {
      final response = await ApiService.updateNotePinned(noteId, !isPinned);
      if (response['success'] == false) {
        Fluttertoast.showToast(msg: response['message']);
        return;
      }
      Fluttertoast.showToast(msg: response['message']);
      getAllNotes();
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Navbar(
          onSearchNote: onSearchNote,
          handleClearSearch: handleClearSearch,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: allNotes.isNotEmpty
            ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: allNotes.length,
                itemBuilder: (context, index) {
                  final note = allNotes[index];
                  return NoteCard(
                    title: note['title'],
                    date: note['createdAt'],
                    content: note['content'],
                    tags: List<String>.from(note['tags']),
                    isPinned: note['isPinned'],
                    onEdit: () => handleEdit(note),
                    onDelete: () => deleteNote(note['_id']),
                    onPinNote: () => updateIsPinned(note['_id'], note['isPinned']),
                  );
                },
              )
            : EmptyCard(
                imgSrc: isSearch
                    ? 'assets/notfound.png'
                    : 'assets/note.jpg',
                message: isSearch
                    ? "No Notes found matching your search"
                    : "Click the 'Add' button to start noting down your thoughts, inspiration, and reminders.",
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isAddEditModalOpen = true;
            modalType = "add";
            noteData = null;
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF2B85FF),
      ),
      bottomSheet: isAddEditModalOpen
          ? Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.75,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AddEditNotes(
                  onClose: () {
                    setState(() {
                      isAddEditModalOpen = false;
                    });
                  },
                  noteData: noteData,
                  type: modalType,
                  getAllNotes: getAllNotes,
                ),
              ),
            )
          : null,
    );
  }
}
