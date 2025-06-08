import 'package:app_livraria/core/widgets/app_header.dart';
import 'package:app_livraria/core/widgets/footer.dart';
import 'package:app_livraria/views/profile/profile_screen.dart';
import 'package:app_livraria/views/search/search_model_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_livraria/core/widgets/book_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _controller = TextEditingController();
  bool _listenersAdded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchViewModel(),
      builder: (context, _) {
        final vm = context.watch<SearchViewModel>();

        if (!_listenersAdded) {
          _controller.addListener(() {
            vm.onSearchTextChanged(
              _controller.text,
              searchUsers: _tabController.index == 1,
            );
          });

          _tabController.addListener(() {
            if (!_tabController.indexIsChanging) {
              vm.onSearchTextChanged(
                _controller.text,
                searchUsers: _tabController.index == 1,
              );
            }
          });

          _listenersAdded = true;
        }

        return Scaffold(
          appBar: AppHeader(title: 'Busca', showBack: true, showCart: true),
          body: Column(
            children: [
              _buildSearchBar(),
              _buildTabBar(),
              Expanded(
                child: _tabController.index == 0
                    ? _buildBookGrid(vm)
                    : _buildUserList(vm),
              ),
              const AppFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Buscar por nome ou título...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _controller.clear(),
                )
              : null,
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: Colors.teal,
      labelColor: Colors.teal,
      unselectedLabelColor: Colors.grey,
      tabs: const [
        Tab(text: 'Livros'),
        Tab(text: 'Usuários'),
      ],
    );
  }

  Widget _buildBookGrid(SearchViewModel vm) {
    if (vm.isLoading && vm.books.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.text.length < 3) {
      return const Center(child: Text('Digite ao menos 3 letras para buscar.'));
    }

    if (vm.books.isEmpty) {
      return const Center(child: Text('Nenhum livro encontrado.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vm.books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (_, i) => BookCard(book: vm.books[i]),
    );
  }

  Widget _buildUserList(SearchViewModel vm) {
    if (vm.isLoading && vm.users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.text.length < 3) {
      return const Center(child: Text('Digite ao menos 3 letras para buscar.'));
    }

    if (vm.users.isEmpty) {
      return const Center(child: Text('Nenhum usuário encontrado.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: vm.users.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, i) {
        final user = vm.users[i];
        return ListTile(
          leading: CircleAvatar(child: Text(user.name[0])),
          title: Text(user.name),
          subtitle: Text(user.bio ?? ''),
          trailing: ElevatedButton(
            onPressed: () {
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: user.id),
                ),
              );
            },
            child: const Text('Ver perfil'),
          ),
        );
      },
    );
  }
}
