import 'package:flutter/material.dart'; // Added for IconData and UserModeEnum
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// An immutable class to hold user-specific economy data and user mode.
class UserDataState {
  final int coins;
  final int xp;
  final int gems;
  final UserModeEnum userMode;

  /// Initializes [UserDataState] with default values.
  const UserDataState({
    required this.coins,
    required this.xp,
    required this.gems,
    required this.userMode,
  });

  /// Creates a copy of this [UserDataState] with the given fields replaced.
  UserDataState copyWith({
    int? coins,
    int? xp,
    int? gems,
    UserModeEnum? userMode,
  }) {
    return UserDataState(
      coins: coins ?? this.coins,
      xp: xp ?? this.xp,
      gems: gems ?? this.gems,
      userMode: userMode ?? this.userMode,
    );
  }
}

/// A [Notifier] to hold and manage user-specific economy data and user mode.
class UserNotifier extends Notifier<UserDataState> {
  /// Initializes [UserNotifier] with default values for coins, XP, gems, and user mode.
  @override
  UserDataState build() {
    return const UserDataState(
      coins: 1200,
      xp: 5000,
      gems: 150,
      userMode: UserModeEnum.alegre,
    );
  }

  /// Sets the user mode to a new value and updates the state.
  void setUserMode(UserModeEnum mode) {
    if (state.userMode != mode) {
      state = state.copyWith(userMode: mode);
    }
  }
}

/// Provider for [UserNotifier].
final userProvider = NotifierProvider<UserNotifier, UserDataState>(
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
