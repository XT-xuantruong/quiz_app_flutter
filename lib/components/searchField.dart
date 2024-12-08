import 'package:flutter/material.dart';
import 'package:quiz_app/screens/search_result_screen.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();

  void _search() {
    String query = _controller.text;
    if (query.isNotEmpty) {

      print("Searching for: $query");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SearchResultScreen(searchTerm: query,))
      );
    } else {
      print("Please enter a search query.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              hintText: 'Search...',

              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _search,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        )
      ],
    );
  }
}
