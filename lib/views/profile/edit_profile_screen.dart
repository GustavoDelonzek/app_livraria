import 'package:app_livraria/core/widgets/app_header.dart';
import 'package:app_livraria/core/widgets/custom_text_field.dart';
import 'package:app_livraria/core/widgets/footer.dart';
import 'package:app_livraria/core/widgets/screen_container.dart';
import 'package:app_livraria/views/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  List<String> selectedGenres = [];

  final List<String> allGenres = [
    'Ficção',
    'Romance',
    'Mistério',
    'Fantasia',
    'Terror',
    'Suspense',
    'História',
    'Autoajuda',
    'Biografia',
    'Aventura',
    'Ciência',
    'Tecnologia',
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileViewModel>().localCurrentUser;
    if (user != null) {
      _nameController.text = user.name;
      _bioController.text = user.bio ?? '';
      selectedGenres = List<String>.from(user.favoriteGenres);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final viewModel = context.read<ProfileViewModel>();
    await viewModel.updateUserProfile(
      name: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      favoriteGenres: selectedGenres,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

 Widget _buildGenreChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,  
      children: allGenres.map((genre) {
        final isSelected = selectedGenres.contains(genre);
        return ChoiceChip(
          label: Text(genre),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedGenres.add(genre);
              } else {
                selectedGenres.remove(genre);
              }
            });
          },
          selectedColor: const Color.fromRGBO(247, 169, 182, 1),
          backgroundColor: Colors.grey.shade200,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }


  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      appBar: AppHeader(title: 'Editar Perfil', showBack: true),
      body: ScreenContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _bioController,
              label: 'Biografia',
            ),
            const SizedBox(height: 24),
            const Text(
              'Gêneros Favoritos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color.fromRGBO(143, 179, 195,1)),
            ),
            const SizedBox(height: 8),
            _buildGenreChips(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: viewModel.isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(143, 179, 195, 1),
                  foregroundColor: Colors.white, 
                ),
                child: viewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppFooter(),
    );
  }
}
