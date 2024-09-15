import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:your_project_name/services/api_service.dart'; // Replace with your actual API service file
import 'package:your_project_name/widgets/profile_info.dart'; // Replace with your actual ProfileInfo widget
import 'package:your_project_name/widgets/search_bar.dart'; // Replace with your actual SearchBar widget

class Navbar extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  final Function(String) onSearchNote;
  final VoidCallback handleClearSearch;

  Navbar({
    required this.userInfo,
    required this.onSearchNote,
    required this.handleClearSearch,
  });

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  String searchQuery = "";

  void handleSearch() {
    if (searchQuery.isNotEmpty) {
      widget.onSearchNote(searchQuery);
    }
  }

  void onClearSearch() {
    setState(() {
      searchQuery = "";
    });
    widget.handleClearSearch();
  }

  Future<void> onLogout() async {
    try {
      final response = await ApiService.signOut(); // Replace with your API call method

      if (!response['success']) {
        Fluttertoast.showToast(msg: response['message']);
        return;
      }

      Fluttertoast.showToast(msg: response['message']);
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
            child: Text(
              'SAVE ME',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            child: SearchBar(
              value: searchQuery,
              onChange: (value) => setState(() => searchQuery = value),
              handleSearch: handleSearch,
              onClearSearch: onClearSearch,
            ),
          ),
          ProfileInfo(userInfo: widget.userInfo, onLogout: onLogout),
        ],
      ),
    );
  }
}
