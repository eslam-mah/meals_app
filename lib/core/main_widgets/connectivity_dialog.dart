// lib/widgets/connectivity_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/core/services/connectivity_service.dart';
import 'package:meals_app/generated/l10n.dart';

class ConnectivityDialog {
  static final Logger _log = Logger('ConnectivityDialog');

  /// Call this whenever you detect a drop in connectivity:
  /// ConnectivityDialog.show(context, onConnected: () { ... });
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConnected,
  }) async {
    _log.info('Showing connectivity dialog');
    if (!context.mounted) {
      _log.warning('Context not mounted, aborting dialog');
      return;
    }

    final navigator = Navigator.of(context, rootNavigator: true);

    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.8),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (dialogContext, _, __) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Wi-Fi Off Icon
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
                      height: 1.4,
                      color: Colors.grey[700],
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Retry Button
                  SizedBox(
                    width: 350.w,
                    height: 55.h,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(
                        S.of(context).tryAgain,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () async {
                        _log.info('Try Again pressed');
                        final overlay = _LoadingOverlay.show(dialogContext);
                        final connected =
                            await ConnectivityService.instance.forceCheck();
                        await Future.delayed(const Duration(milliseconds: 500));
                        overlay.hide();

                        if (connected) {
                          _log.info('Connection restored → closing dialog');
                          if (dialogContext.mounted) {
                            navigator.pop();
                            onConnected();
                          }
                        } else {
                          _log.info('Still no connection');
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(
                              content: Text(
                                S.of(dialogContext).noInternetConnection,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    _log.info('Connectivity dialog dismissed');
  }
}

/// Simple full-screen loading overlay
class _LoadingOverlay {
  final OverlayEntry _entry;
  _LoadingOverlay._(this._entry);

  static _LoadingOverlay show(BuildContext context) {
    final overlayEntry = OverlayEntry(
      builder:
          (_) => Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
    );
    Overlay.of(context)!.insert(overlayEntry);
    return _LoadingOverlay._(overlayEntry);
  }

  void hide() {
    _entry.remove();
  }
}
