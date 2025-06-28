import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/config/colors_box.dart';

/// A custom notification widget that displays in-app notifications with a beautiful design.
/// 
/// Features:
/// - Animated entrance and exit
/// - Configurable icon, colors, and duration
/// - Auto-dismissal with optional manual dismissal
/// - Support for both overlay and ScaffoldMessenger display methods
/// - Clean, modern design with shadow effects
class CustomNotification extends StatelessWidget {
  /// The title of the notification.
  final String title;

  /// The message content of the notification.
  final String message;

  /// The icon to display in the notification.
  final IconData icon;

  /// The background color of the notification.
  final Color backgroundColor;

  /// The text color for the notification content.
  final Color textColor;

  /// Duration for which the notification should be displayed.
  final Duration duration;
  
  /// Whether to show a close button.
  final bool showCloseButton;
  
  /// Callback when the notification is tapped.
  final VoidCallback? onTap;

  /// Creates a new CustomNotification widget.
  const CustomNotification({
    Key? key,
    required this.title,
    required this.message,
    this.icon = Icons.notifications,
    this.backgroundColor = ColorsBox.primaryColor,
    this.textColor = Colors.white,
    this.duration = const Duration(seconds: 3),
    this.showCloseButton = true,
    this.onTap,
  }) : super(key: key);

  /// Shows the custom notification using the overlay system.
  /// 
  /// This method creates a notification that appears from the top of the screen
  /// with a sliding animation.
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    IconData icon = Icons.notifications,
    Color backgroundColor = ColorsBox.primaryColor,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    final overlayState = Overlay.of(context);
    
    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (context) => _NotificationOverlay(
        title: title,
        message: message,
        icon: icon,
        backgroundColor: backgroundColor,
        textColor: textColor,
        onDismiss: () {
          entry?.remove();
        },
        onTap: onTap,
      ),
    );

    overlayState.insert(entry);

    // Auto-dismiss after duration
    Future.delayed(duration, () {
      entry?.remove();
    });
  }

  /// Shows the custom notification using the provided scaffold messenger state.
  /// 
  /// This method is useful when you need to show notifications from places
  /// where BuildContext might not be directly available (like in the main function).
  static void showWithScaffoldMessenger({
    required ScaffoldMessengerState scaffoldMessenger,
    required String title,
    required String message,
    IconData icon = Icons.notifications,
    Color backgroundColor = ColorsBox.primaryColor,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        margin: EdgeInsets.only(
          // bottom: 80.h,
          left: 20.w,
          right: 20.w,
        ),
        dismissDirection: DismissDirection.up,
        content: CustomNotification(
          title: title,
          message: message,
          icon: icon,
          backgroundColor: backgroundColor,
          textColor: textColor,
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.25),
                  child: Icon(
                    icon,
                    color: textColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (message.isNotEmpty) SizedBox(height: 4.h),
                      if (message.isNotEmpty)
                        Text(
                          message,
                          style: TextStyle(
                            color: textColor.withOpacity(0.9),
                            fontSize: 16.sp,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (showCloseButton) SizedBox(width: 8.w),
                if (showCloseButton) 
                  IconButton(
                    icon: Icon(
                      Icons.close, 
                      color: textColor.withOpacity(0.7),
                      size: 20.r,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A private class that handles the overlay display for the notification.
class _NotificationOverlay extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onDismiss;
  final VoidCallback? onTap;

  const _NotificationOverlay({
    required this.title,
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onDismiss,
    this.onTap,
  });

  @override
  State<_NotificationOverlay> createState() => _NotificationOverlayState();
}

class _NotificationOverlayState extends State<_NotificationOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<double>(
      begin: -50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 70.h,
      left: 20.w,
      right: 20.w,
      child: GestureDetector(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
          widget.onDismiss();
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Stack(
                  children: [
                    CustomNotification(
                      title: widget.title,
                      message: widget.message,
                      icon: widget.icon,
                      backgroundColor: widget.backgroundColor,
                      textColor: widget.textColor,
                      onTap: widget.onTap,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: widget.onDismiss,
                          borderRadius: BorderRadius.circular(20.r),
                          child: Padding(
                            padding: EdgeInsets.all(8.r),
                            child: Icon(
                              Icons.close,
                              color: widget.textColor.withOpacity(0.7),
                              size: 20.r,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 