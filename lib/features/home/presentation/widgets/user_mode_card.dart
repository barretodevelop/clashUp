import 'package:aplicativo_social/features/user/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A reusable widget to display the user's current mode and allow selection.
class UserModeCard extends ConsumerStatefulWidget {
  const UserModeCard({Key? key}) : super(key: key);

  @override
  ConsumerState<UserModeCard> createState() => _UserModeCardState();
}

class _UserModeCardState extends ConsumerState<UserModeCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  UserModeEnum? _animatingUserMode;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // After animation, clear the animating state
        setState(() {
          _animatingUserMode = null;
        });
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onModeSelected(UserModeEnum selectedMode) {
    final UserDataState userData = ref.read(userProvider);

    // Only animate if a different mode is selected
    if (userData.userMode != selectedMode) {
      setState(() {
        _animatingUserMode = selectedMode;
      });
      _animationController.forward().then((_) {
        // After the animation finishes, update the user mode in the state
        ref.read(userProvider.notifier).setUserMode(selectedMode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserDataState userData = ref.watch(userProvider);
    final UserModeEnum currentMode = userData.userMode;

    return Card(
      // margin: const EdgeInsets.symmetric(vertical: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Horizontal list of modes
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: UserModeEnum.values.map<Widget>((mode) {
                      final bool isSelected = (mode == currentMode);
                      return GestureDetector(
                        onTap: () => _onModeSelected(mode),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                mode.icon,
                                size: isSelected
                                    ? 48.0
                                    : 32.0, // Larger if selected
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).disabledColor,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                mode.displayName,
                                style: TextStyle(
                                  fontSize: isSelected ? 12.0 : 10.0,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).disabledColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Animated icon overlay
          if (_animatingUserMode != null)
            AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext context, Widget? child) {
                return Center(
                  child: Transform.translate(
                    offset:
                        Offset(0, -(_animation.value * 50)), // Move up by 50px
                    child: Opacity(
                      opacity: 1.0 - _animation.value, // Fade out
                      child: Transform.scale(
                        scale: 1.0 +
                            (_animation.value * 0.3), // Grow up to 30% larger
                        child: Icon(
                          _animatingUserMode!.icon,
                          size: 48.0, // Fixed size for the icon itself
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
