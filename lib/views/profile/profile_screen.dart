import 'package:app_livraria/core/widgets/app_header.dart';
import 'package:app_livraria/core/widgets/footer.dart';
import 'package:app_livraria/core/widgets/genre_badge.dart';
import 'package:app_livraria/core/widgets/screen_container.dart';
import 'package:app_livraria/models/user.dart';
import 'package:app_livraria/views/auth/auth_view_model.dart';
import 'package:app_livraria/views/profile/edit_profile_screen.dart';
import 'package:app_livraria/views/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
   bool _loaded = false;

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      if (!_loaded && widget.userId != null) {
        Provider.of<ProfileViewModel>(context, listen: false)
            .loadUserById(widget.userId!);
        _loaded = true;
      }
    }


  void _showProfileOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blueAccent),
                title: const Text('Editar Perfil'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text('Sair da Conta'),
                onTap: () async {
                  Navigator.pop(context);
                  await Provider.of<AuthViewModel>(context, listen: false).logout();
                  Navigator.pushReplacementNamed(context, '/auth');
                },
              ),
            ],
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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppHeader(title: 'Perfil', showBack: true, showCart: true,  onMore: () => isOwnProfile ? _showProfileOptions(context) : ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Função de denunciar usuário ainda não implementada.')),
                    )),
          bottomNavigationBar: const AppFooter(),
          body: SafeArea(
            child: ScreenContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 56,
                          backgroundColor: Colors.grey[300],
                          child: Text(
                            user.name.isNotEmpty
                                ? user.name.substring(0, 2).toUpperCase()
                                : '',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.bio ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  viewModel.formatFollowerCount(user.followingCount),
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Seguindo',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 32),
                            Column(
                              children: [
                                Text(
                                  viewModel.formatFollowerCount(user.followersCount),
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Seguidores',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                       if (!isOwnProfile)
                         AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(scale: animation, child: child);
                          },
                          child: ElevatedButton(
                            key: ValueKey<bool>(viewModel.isFollowing(user.id)),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                return viewModel.isFollowing(user.id)
                                    ? const Color.fromRGBO(247, 169, 182, 1)
                                    : const Color.fromRGBO(143, 179, 195, 1);
                              }),
                              foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                return viewModel.isFollowing(user.id) ? Colors.white : Colors.black;
                              }),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              elevation: MaterialStateProperty.all(6),
                              shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.2)),
                            ),
                            onPressed: () async {
                              await viewModel.toggleFollow(user.id);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: Text(
                                viewModel.isFollowing(user.id) ? 'Unfollow' : 'Follow',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Gêneros Favoritos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  user.favoriteGenres.isNotEmpty ?
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: user.favoriteGenres.map((genre) {
                        return GenreBadge(genre: genre);
                      }).toList(),
                    )
                  : const Text('Usuário não possui gêneros favoritos'),

                  const SizedBox(height: 24),

                  const Text(
                    'Minhas Avaliações',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),

                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
