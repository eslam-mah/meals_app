import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/services/connectivity_service.dart';
import 'package:meals_app/generated/l10n.dart';
import 'package:logging/logging.dart';

/// Shows a full-screen dialog when there's no internet connection
class ConnectivityDialog {
  static final Logger _log = Logger('ConnectivityDialog');

  /// Shows a full-screen dialog when there is no internet connection
  /// The dialog has a "Try Again" button that checks connectivity
  /// and calls [onConnected] when internet is restored
  static Future<void> show(BuildContext context, {required Function() onConnected}) async {
    _log.info('Attempting to show connectivity dialog');
    
    if (!context.mounted) {
      _log.warning('Context not mounted when showing dialog');
      return;
    }
    
    try {
      _log.info('Showing dialog now');
      
      // Make sure we're using the root navigator to avoid any overlay issues
      final navigator = Navigator.of(context, rootNavigator: true);
      
      // This will ensure the dialog is shown above everything else
      await showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.8),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (BuildContext dialogContext, _, __) {
          return PopScope(
            // Prevent back button from dismissing dialog
            canPop: false,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Animation container
                                Container(
                                  width: 140.w,
                                  height: 140.w,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.wifi_off_rounded,
                                    size: 80.w,
                                    color: Colors.red,
                                  ),
                                ),
                                
                                SizedBox(height: 40.h),
                                
                                // Title
                                Text(
                                  S.of(context).noInternetConnection,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                
                                SizedBox(height: 16.h),
                                
                                // Description
                                Text(
                                  'Please check your internet connection and try again.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                ),
                                
                                SizedBox(height: 40.h),
                                
                                // Try Again button
                                _RetryButton(
                                  onPressed: () async {
                                    _log.info('Try Again button pressed');
                                    
                                    try {
                                      // Show loading indicator
                                      final loadingOverlay = _LoadingOverlay.show(dialogContext);
                                      
                                      // Force a connectivity check
                                      final isConnected = await ConnectivityService.instance.forceCheck();
                                      _log.info('Connection check result: $isConnected');
                                      
                                      // Delay to ensure user sees the loading indicator
                                      await Future.delayed(const Duration(milliseconds: 500));
                                      
                                      // Hide loading indicator
                                      loadingOverlay.hide();
                                      
                                      if (isConnected) {
                                        _log.info('Connection restored, closing dialog');
                                        
                                        if (dialogContext.mounted) {
                                          navigator.pop();
                                          onConnected();
                                        }
                                      } else {
                                        _log.info('Still disconnected');
                                        // Vibrate or show a toast that connection is still not available
                                      }
                                    } catch (e) {
                                      // Handle any errors during connectivity check
                                      _log.severe('Error checking connectivity: $e');
                                      _LoadingOverlay.hideGlobal(dialogContext);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Bottom info text
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Text(
                        'You need an active internet connection to use this app.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
      
      _log.info('Dialog closed');
    } catch (e) {
      // Handle any errors showing the dialog
      _log.severe('Error showing connectivity dialog: $e');
    }
  }
}

/// A custom retry button for better visual appearance
class _RetryButton extends StatelessWidget {
  final VoidCallback onPressed;
  
  const _RetryButton({required this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Theme.of(context).primaryColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.refresh_rounded),
            SizedBox(width: 8.w),
            Text(
              S.of(context).tryAgain,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A simple loading overlay with a semi-transparent background
class _LoadingOverlay {
  final BuildContext context;
  final OverlayEntry _overlayEntry;
  
  _LoadingOverlay._(this.context, this._overlayEntry);
  
  /// Shows a loading overlay over the entire screen
  static _LoadingOverlay show(BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black.withOpacity(0.5),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3.0,
          ),
        ),
      ),
    );
    
    overlay.insert(overlayEntry);
    return _LoadingOverlay._(context, overlayEntry);
  }
  
  /// Hides the loading overlay
  void hide() {
    _overlayEntry.remove();
  }
  
  /// Helper method to hide global loading overlay (safety method)
  static void hideGlobal(BuildContext context) {
    try {
      Navigator.of(context).pop();
    } catch (e) {
      // Ignore errors
    }
  }
} 