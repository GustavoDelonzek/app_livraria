import 'package:app_livraria/core/services/google_books_service.dart';
import 'package:app_livraria/core/widgets/app_header.dart';
import 'package:app_livraria/core/widgets/footer.dart';
import 'package:app_livraria/core/widgets/genre_badge.dart';
import 'package:app_livraria/core/widgets/review_card.dart';
import 'package:app_livraria/core/widgets/screen_container.dart';
import 'package:app_livraria/models/user.dart';
import 'package:app_livraria/views/auth/auth_view_model.dart';
import 'package:app_livraria/views/book_details/book_details_screen.dart';
import 'package:app_livraria/views/profile/edit_profile_screen.dart';
import 'package:app_livraria/views/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppColors {
  static const Color primaryPink = Color(0xFFF7A9B6);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color lightPink = Color(0xFFFCE4EC);
  static const Color darkPink = Color(0xFFE57373);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color textDark = Color(0xFF424242);
  static const Color textLight = Color(0xFF757575);
}

class ProfileScreen extends StatefulWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loaded = false;

  Future<void> _openBookDetails(String bookId) async {
    final service = GoogleBooksService();
    final book = await service.fetchBookById(bookId);

    if (book != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookDetailsScreen(book: book),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Livro não encontrado'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_loaded) {
      _loadProfileData();
      _loaded = true;
    }
  }

  Future<void> _loadProfileData() async {
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);

    if (widget.userId != null) {
      await viewModel.loadUserById(widget.userId!);
    } else {
      final currentUserId = viewModel.localCurrentUser?.id;

      if (currentUserId != null) {
        await viewModel.loadUserById(currentUserId);
      } else {
        await viewModel.fetchCurrentUser();

        if (viewModel.localCurrentUser?.id != null) {
          await viewModel.loadUserById(viewModel.localCurrentUser!.id);
        }
      }
    }
  }

  void _showProfileOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.lightPink,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      color: AppColors.primaryPink,
                    ),
                  ),
                  title: const Text(
                    'Editar Perfil',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.logout_rounded,
                      color: Colors.red[400],
                    ),
                  ),
                  title: Text(
                    'Sair da Conta',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red[400],
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await Provider.of<AuthViewModel>(context, listen: false).logout();
                    Navigator.pushReplacementNamed(context, '/auth');
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        final currentUser = viewModel.localCurrentUser;
        final isOwnProfile = widget.userId == null || widget.userId == currentUser?.id;
        final UserLocal? user = isOwnProfile ? currentUser : viewModel.viewedUser;

        if (viewModel.isLoading || user == null) {
          return Scaffold(
            appBar: AppHeader(title: 'Perfil', showBack: true, showCart: true),
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
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryPink,
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppHeader(
            title: 'Perfil',
            showBack: true,
            showCart: true,
            onMore: () => isOwnProfile
                ? _showProfileOptions(context)
                : ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Função de denunciar usuário ainda não implementada.'),
                      backgroundColor: AppColors.primaryPink,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
          ),
          bottomNavigationBar: const AppFooter(),
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
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.primaryPink, AppColors.primaryGreen],
                              ),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: CircleAvatar(
                              radius: 56,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 52,
                                backgroundColor: AppColors.lightPink,
                                child: Text(
                                  user.name.isNotEmpty
                                      ? user.name.substring(0, 2).toUpperCase()
                                      : '',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryPink,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (user.bio != null && user.bio!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.lightPink.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                user.bio!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textLight,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          const SizedBox(height: 20),

                          Consumer<ProfileViewModel>(
                            builder: (context, viewModel, child) {
                              final user = viewModel.localCurrentUser;
                              if (user == null) {
                                return const CircularProgressIndicator(
                                  color: AppColors.primaryPink,
                                );
                              }

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStatItem(
                                    viewModel.formatFollowerCount(user.followingCount),
                                    'Seguindo',
                                    AppColors.primaryPink,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 1,
                                    color: Colors.grey[300],
                                  ),
                                  _buildStatItem(
                                    viewModel.formatFollowerCount(user.followersCount),
                                    'Seguidores',
                                    AppColors.primaryGreen,
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          if (!isOwnProfile)
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(scale: animation, child: child);
                              },
                              child: Container(
                                key: ValueKey<bool>(viewModel.isFollowing(user.id)),
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: viewModel.isFollowing(user.id)
                                        ? AppColors.primaryGreen
                                        : AppColors.primaryPink,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () async {
                                    await viewModel.toggleFollow(user.id);
                                  },
                                  icon: Icon(
                                    viewModel.isFollowing(user.id)
                                        ? Icons.person_remove_rounded
                                        : Icons.person_add_rounded,
                                  ),
                                  label: Text(
                                    viewModel.isFollowing(user.id) ? 'Deixar de Seguir' : 'Seguir',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Gêneros Favoritos',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          user.favoriteGenres.isNotEmpty
                              ? Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: user.favoriteGenres.map((genre) {
                                    return GenreBadge(genre: genre);
                                  }).toList(),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGreen.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.category_outlined,
                                        color: AppColors.primaryGreen,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Nenhum gênero favorito definido',
                                        style: TextStyle(
                                          color: AppColors.textLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.primaryPink,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Minhas Avaliações',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    viewModel.userReviews.isNotEmpty
                        ? Column(
                            children: viewModel.userReviews.map((review) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ReviewCard(
                                  review: review,
                                  onTapBook: () => _openBookDetails(review.bookId),
                                ),
                              );
                            }).toList(),
                          )
                        : Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.rate_review_outlined,
                                  color: AppColors.primaryPink,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Nenhuma avaliação encontrada',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String count, String label, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}