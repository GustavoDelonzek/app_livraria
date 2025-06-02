import 'package:app_livraria/core/widgets/app_header.dart';
import 'package:app_livraria/core/widgets/footer.dart';
import 'package:app_livraria/views/search/search_model_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_livraria/core/widgets/book_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchViewModel(),
      child: Scaffold(
        appBar: AppHeader(title: 'Busca', showBack: true),
        body: const SearchContent(),
      ),
    );
  }
}

class SearchContent extends StatefulWidget {
  const SearchContent({super.key});

  @override
  State<SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final vm = context.read<SearchViewModel>();
      vm.onSearchTextChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Buscar por título, autor ou ISBN...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (vm.books.isEmpty && !vm.isLoading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Digite ao menos 3 letras para buscar livros.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        Expanded(
          child: vm.isLoading && vm.books.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: vm.books.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (_, index) {
                    return BookCard(book: vm.books[index]);
                  },
                ),
        ),
        const AppFooter(),
      ],
    );
  }
}
