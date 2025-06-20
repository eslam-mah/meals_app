import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/features/feedback/view_model/cubits/feedback_cubit.dart';
import 'package:meals_app/features/feedback/view_model/cubits/feedback_state.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/generated/l10n.dart';

class FeedbackView extends StatefulWidget {
  static const String feedbackPath = '/feedback';

  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  int? foodQualityRating;
  int? serviceSpeedRating;
  int? orderEaseRating;
  int? overallRating;
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    // Get user's phone number from UserCubit
    final String? phoneNumber = context.read<UserCubit>().phoneNumber;

    return BlocListener<FeedbackCubit, FeedbackState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          setState(() {
            _isSubmitting = true;
          });
        } else {
          setState(() {
            _isSubmitting = false;
          });
          
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localization.feedbackSubmittedSuccessfully),
                backgroundColor: Colors.green,
              ),
            );
            GoRouter.of(context).pop();
          } else if (state.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? localization.failedToLoadCart),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: Text(
            localization.feedback,
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 28.r),
            onPressed: () => GoRouter.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Details Section
                _buildSectionTitle(localization.personalDetails),
                SizedBox(height: 16.h),
  
                // Phone Number Field
                Text(
                  localization.phoneNumber,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
  
                  ),
                  child: Text(
                    phoneNumber ?? '-',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 24.h),
  
                // Rating Section
                _buildSectionTitle(localization.rating),
                SizedBox(height: 16.h),
  
                // Food Quality Rating
                _buildRatingQuestion(
                  question:
                      '1- ${localization.howSatisfiedAreYouWithFoodQuality}',
                  currentRating: foodQualityRating,
                  onRatingSelected: (rating) {
                    setState(() {
                      foodQualityRating = rating;
                    });
                  },
                ),
                SizedBox(height: 24.h),
  
                // Service Speed Rating
                _buildRatingQuestion(
                  question:
                      '2- ${localization.howSatisfiedAreYouWithServiceSpeed}',
                  currentRating: serviceSpeedRating,
                  onRatingSelected: (rating) {
                    setState(() {
                      serviceSpeedRating = rating;
                    });
                  },
                ),
                SizedBox(height: 24.h),
  
                // Order Ease Rating
                _buildRatingQuestion(
                  question: '3- ${localization.howEasyToMakeOrder}',
                  currentRating: orderEaseRating,
                  onRatingSelected: (rating) {
                    setState(() {
                      orderEaseRating = rating;
                    });
                  },
                ),
                SizedBox(height: 24.h),
  
                // Overall Section
                _buildSectionTitle(localization.overall),
                SizedBox(height: 16.h),
  
                // Overall Satisfaction
                _buildOverallQuestion(
                  question: '1- ${localization.howSatisfiedWithOverallService}',
                  currentRating: overallRating,
                  onRatingSelected: (rating) {
                    setState(() {
                      overallRating = rating;
                    });
                  },
                ),
                SizedBox(height: 24.h),
  
                // Feedback Text
                Text(
                  '2- ${localization.leaveUsFeedback}',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TextField(
                    controller: _feedbackController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: localization.typeYourFeedback,
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14.sp,
                      ),
                      contentPadding: EdgeInsets.all(16.r),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
  
                // Submit Button
                CustomButton(
                  title: _isSubmitting ? '${localization.submit}...' : localization.submit,
                  onTap: _isSubmitting ? () {} : _submitFeedback,
                  width: double.infinity,
                  color: _canSubmit() ? ColorsBox.primaryColor : Colors.grey,
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  // Emoji Rating Question Widget
  Widget _buildRatingQuestion({
    required String question,
    required int? currentRating,
    required Function(int) onRatingSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildEmojiOption(
              1,
              FontAwesomeIcons.faceFrown,
              Colors.red.shade300,
              currentRating,
              onRatingSelected,
            ),
            _buildEmojiOption(
              2,
              FontAwesomeIcons.faceRollingEyes,
              Colors.amber.shade100,
              currentRating,
              onRatingSelected,
            ),
            _buildEmojiOption(
              3,
              FontAwesomeIcons.faceMeh,
              Colors.amber.shade100,
              currentRating,
              onRatingSelected,
            ),
            _buildEmojiOption(
              4,
              FontAwesomeIcons.faceSmile,
              Colors.amber.shade100,
              currentRating,
              onRatingSelected,
            ),
            _buildEmojiOption(
              5,
              FontAwesomeIcons.faceGrinSquint,
              Colors.amber.shade100,
              currentRating,
              onRatingSelected,
            ),
          ],
        ),
      ],
    );
  }

  // Emoji Option Widget
  Widget _buildEmojiOption(
    int value,
    IconData icon,
    Color color,
    int? currentRating,
    Function(int) onRatingSelected,
  ) {
    final isSelected = currentRating == value;

    return GestureDetector(
      onTap: () => onRatingSelected(value),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.r),
          border:
              isSelected
                  ? Border.all(color: ColorsBox.primaryColor, width: 2.w)
                  : null,
        ),
        child: FaIcon(
          icon,
          color: isSelected ? ColorsBox.primaryColor : Colors.black87,
          size: 24.r,
        ),
      ),
    );
  }

  // Overall Rating Question Widget
  Widget _buildOverallQuestion({
    required String question,
    required int? currentRating,
    required Function(int) onRatingSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildThumbOption(
              0,
              FontAwesomeIcons.thumbsDown,
              currentRating,
              onRatingSelected,
            ),
            SizedBox(width: 48.w),
            _buildThumbOption(
              1,
              FontAwesomeIcons.thumbsUp,
              currentRating,
              onRatingSelected,
            ),
          ],
        ),
      ],
    );
  }

  // Thumb Option Widget
  Widget _buildThumbOption(
    int value,
    IconData icon,
    int? currentRating,
    Function(int) onRatingSelected,
  ) {
    final isSelected = currentRating == value;

    return GestureDetector(
      onTap: () => onRatingSelected(value),
      child: FaIcon(
        icon,
        color: isSelected ? ColorsBox.primaryColor : Colors.grey.shade400,
        size: 36.r,
      ),
    );
  }

  // Check if can submit
  bool _canSubmit() {
    return !_isSubmitting && 
        foodQualityRating != null &&
        serviceSpeedRating != null &&
        orderEaseRating != null &&
        overallRating != null;
  }

  // Submit Feedback
  void _submitFeedback() {
    if (_canSubmit()) {
      // Get user's phone number from UserCubit
      final String? phoneNumber = context.read<UserCubit>().phoneNumber;
      
      // Submit feedback using the cubit
      context.read<FeedbackCubit>().submitFeedback(
        rating1: foodQualityRating!,
        rating2: serviceSpeedRating!,
        rating3: orderEaseRating!,
        overallRate: overallRating!,
        comment: _feedbackController.text.trim().isEmpty ? null : _feedbackController.text.trim(),
        phoneNumber: phoneNumber,
      );
    }
  }
}
