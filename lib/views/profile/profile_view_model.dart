import 'package:app_livraria/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserLocal? localCurrentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchOrCreateUser(String uid, String email) async {
    final docRef = _firestore.collection('users').doc(uid);
    final doc = await docRef.get();

    if (doc.exists) {
      localCurrentUser = UserLocal.fromMap(doc.data()!, uid);
    } else {
      final newUser = UserLocal(
        id: uid,
        name: email.split('@')[0],
        bio: '',
        followersCount: 0,
        followingCount: 0,
        favoriteGenres: [],
        followers: [],
        following: [],
      );
      await docRef.set(newUser.toMap());
      localCurrentUser = newUser;
    }

    notifyListeners();
  }

  String formatFollowerCount([int ?count]) {
    if (count == null) {
      return '0';
    }

    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
  
  Future<UserLocal?> getUserById(String? id) async {
    final doc = await _firestore.collection('users').doc(id).get();

    if (doc.exists) {
      return UserLocal.fromMap(doc.data()!, doc.id);
    }

    return null;
  }

  Future<void> toggleFollow(String targetUserId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final usersRef = FirebaseFirestore.instance.collection('users');
    final currentUserRef = usersRef.doc(currentUserId);
    final targetUserRef = usersRef.doc(targetUserId);

    final currentSnapshot = await currentUserRef.get();
    final targetSnapshot = await targetUserRef.get();

    final currentUserData = currentSnapshot.data()!;
    final targetUserData = targetSnapshot.data()!;

    List<String> currentFollowing =
        List<String>.from(currentUserData['following'] ?? []);
    List<String> targetFollowers =
        List<String>.from(targetUserData['followers'] ?? []);

    int currentFollowingCount = currentUserData['followingCount'] ?? 0;
    int targetFollowersCount = targetUserData['followersCount'] ?? 0;

    final isFollowing = currentFollowing.contains(targetUserId);

    if (isFollowing) {
      currentFollowing.remove(targetUserId);
      targetFollowers.remove(currentUserId);
      currentFollowingCount--;
      targetFollowersCount--;
    } else {
      currentFollowing.add(targetUserId);
      targetFollowers.add(currentUserId);
      currentFollowingCount++;
      targetFollowersCount++;
    }

    await currentUserRef.update({
      'following': currentFollowing,
      'followingCount': currentFollowingCount,
    });

    await targetUserRef.update({
      'followers': targetFollowers,
      'followersCount': targetFollowersCount,
    });

    await fetchCurrentUser();
    notifyListeners();
  }

  Future<void> fetchCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (userDoc.exists) {
      localCurrentUser = UserLocal.fromMap(userDoc.data()!, uid);
      notifyListeners();
    }
  }

  bool isFollowing(String userId) {
    final currentUser = localCurrentUser;
    if (currentUser == null) return false;
    return currentUser.following.contains(userId);
  }

  Future<void> updateUserProfile({
    required String name,
    required String bio,
    List<String>? favoriteGenres,
  }) async {
        _isLoading = true;
        notifyListeners();

        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid == null) return;

        final Map<String, dynamic> data = {
          'name': name,
          'bio': bio,
        };

        if (favoriteGenres != null) {
          data['favoriteGenres'] = favoriteGenres;
        }

        await FirebaseFirestore.instance.collection('users').doc(uid).update(data);
        await fetchCurrentUser();
        _isLoading = false;
        notifyListeners();
  }

}
