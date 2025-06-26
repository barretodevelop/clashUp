import 'package:clashup/models/user_model.dart';
import 'package:clashup/providers/auth_provider.dart';
import 'package:clashup/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages modifications to the user's data.
/// It now manages the full UserModel.
class UserNotifier extends Notifier<UserModel?> {
  /// Initializes [UserNotifier] and sets up listener for AuthState changes.
  @override
  UserModel? build() {
    // This provider now mirrors the user object from AuthProvider.
    // It serves as the dedicated entry point for UI components to get user data
    // and for them to request modifications to it.
    return ref.watch(authProvider.select((state) => state.user));
  }

  /// Updates the user data in the provider's state.
  /// This is useful for local updates (e.g., after onboarding) without re-fetching from Firestore.
  void updateUser(UserModel updatedUser) {
    // This method is for local updates. It should update the central source of truth.
    ref.read(authProvider.notifier).updateUserWithOnboardingData(updatedUser);
  }

  /// Sets the user mode to a new value and updates the state.
  Future<void> setUserMode(UserModeEnum mode) async {
    final user = state;
    if (user != null && user.currentMood != mode.name) {
      // 1. Optimistically update the UI by updating the central state
      final updatedUser = user.copyWith(currentMood: () => mode.name);
      ref.read(authProvider.notifier).updateUserWithOnboardingData(updatedUser);

      // 2. Persist the change to Firestore
      try {
        await FirestoreService()
            .updateUser(user.uid, {'currentMood': mode.name});
        print('UserNotifier: User mood updated in Firestore to ${mode.name}');
      } catch (e) {
        // 3. If Firestore update fails, revert the optimistic update
        // by refreshing the user data from the database.
        print(
            'UserNotifier: Failed to update mood in Firestore, reverting. Error: $e');
        await ref.read(authProvider.notifier).refreshUser();
      }
    }
  }
}

/// Provider for [UserNotifier].
final userProvider = NotifierProvider<UserNotifier, UserModel?>(
  UserNotifier.new,
);

/// An enum to represent different user "modes" or statuses.
enum UserModeEnum { triste, alegre, aventureiro, calmo, misterioso }

/// Extension to provide display names and icons for [UserModeEnum] values.
extension UserModeExtension on UserModeEnum {
  String get displayName {
    switch (this) {
      case UserModeEnum.triste:
        return 'Triste';
      case UserModeEnum.alegre:
        return 'Alegre';
      case UserModeEnum.aventureiro:
        return 'Aventureiro';
      case UserModeEnum.calmo:
        return 'Calmo';
      case UserModeEnum.misterioso:
        return 'Misterioso';
    }
  }

  IconData get icon {
    switch (this) {
      case UserModeEnum.triste:
        return Icons.sentiment_dissatisfied;
      case UserModeEnum.alegre:
        return Icons.sentiment_satisfied_alt;
      case UserModeEnum.aventureiro:
        return Icons.hiking;
      case UserModeEnum.calmo:
        return Icons.self_improvement;
      case UserModeEnum.misterioso:
        return Icons.blur_on;
    }
  }
}

// Helper to convert UserModeEnum to UserModel's currentMood string
extension UserModeEnumToName on UserModeEnum {
  String get name {
    return toString().split('.').last;
  }
}
