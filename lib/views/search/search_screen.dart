import 'package:app_livraria/core/widgets/app_header.dart';
import 'package:app_livraria/core/widgets/footer.dart';
import 'package:app_livraria/views/profile/profile_screen.dart';
import 'package:app_livraria/views/search/search_model_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_livraria/core/widgets/book_card.dart';

class AppColors {
  static const Color primaryPink = Color(0xFFF7A9B6);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color lightPink = Color(0xFFFCE4EC);
  static const Color darkPink = Color(0xFFE57373);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color textDark = Color(0xFF424242);
  static const Color textLight = Color(0xFF757575);
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _controller = TextEditingController();
  bool _listenersAdded = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    _searchFocusNode.dispose();
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
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  AppColors.lightPink.withOpacity(0.1),
                ],
              ),
            ),
            child: Column(
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
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: 'Buscar por nome ou título...',
          hintStyle: TextStyle(
            color: AppColors.textLight,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.primaryPink,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: AppColors.primaryPink,
                  ),
                  onPressed: () => _controller.clear(),
                )
              : null,
          filled: true,
          fillColor: AppColors.lightPink.withOpacity(0.2),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.primaryPink.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.primaryPink,
              width: 2,
            ),
          ),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primaryPink,
        indicatorWeight: 3,
        labelColor: AppColors.primaryPink,
        unselectedLabelColor: AppColors.textLight,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
        tabs: const [
          Tab(text: 'Livros'),
          Tab(text: 'Usuários'),
        ],
      ),
    );
  }

  Widget _buildBookGrid(SearchViewModel vm) {
    if (vm.isLoading && vm.books.isEmpty) {
      return _buildLoadingState();
    }

    if (_controller.text.length < 3) {
      return _buildInitialState();
    }

    if (vm.books.isEmpty) {
      return _buildEmptyState('Nenhum livro encontrado para "${_controller.text}"');
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vm.books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (_, i) => BookCard(book: vm.books[i]),
    );
  }

  Widget _buildUserList(SearchViewModel vm) {
    if (vm.isLoading && vm.users.isEmpty) {
      return _buildLoadingState();
    }

    if (_controller.text.length < 3) {
      return _buildInitialState();
    }

    if (vm.users.isEmpty) {
      return _buildEmptyState('Nenhum usuário encontrado para "${_controller.text}"');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: vm.users.length,
      separatorBuilder: (_, __) => Divider(
        color: Colors.grey.withOpacity(0.2),
        height: 1,
      ),
      itemBuilder: (_, i) {
        final user = vm.users[i];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryGreen,
              child: Text(
                user.name[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              user.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textDark,
              ),
            ),
            subtitle: Text(
              user.bio ?? 'Sem biografia',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textLight,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(userId: user.id),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Ver perfil',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryPink,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Buscando...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.lightPink.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search,
              size: 48,
              color: AppColors.primaryPink,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Digite ao menos 3 letras para buscar',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Você pode buscar por livros ou usuários',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.lightPink.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _tabController.index == 0 ? Icons.book_outlined : Icons.person_off,
              size: 48,
              color: AppColors.primaryPink,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tente usar termos diferentes',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}