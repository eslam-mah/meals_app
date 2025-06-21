// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(error) => "Failed to get location: ${error}";

  static String m1(error) => "Failed to save address: ${error}";

  static String m2(name) => "Hello, ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accessLocation":
            MessageLookupByLibrary.simpleMessage("ACCESS LOCATION"),
        "accountDetails":
            MessageLookupByLibrary.simpleMessage("Account details"),
        "accountInfo": MessageLookupByLibrary.simpleMessage("Account info"),
        "addAddress": MessageLookupByLibrary.simpleMessage("Add Address"),
        "addItemsToYourCart": MessageLookupByLibrary.simpleMessage(
            "Add items to your cart to continue"),
        "addMoreItems": MessageLookupByLibrary.simpleMessage("Add more items"),
        "addNewAddress":
            MessageLookupByLibrary.simpleMessage("Add new address"),
        "addToCart": MessageLookupByLibrary.simpleMessage("Add to Cart"),
        "addYourFirstAddress": MessageLookupByLibrary.simpleMessage(
            "Add your first address by clicking the button below"),
        "addedToCart":
            MessageLookupByLibrary.simpleMessage("Added to cart successfully!"),
        "addressNotFound":
            MessageLookupByLibrary.simpleMessage("Address not found"),
        "alexandria": MessageLookupByLibrary.simpleMessage("Alexandria"),
        "alreadyHaveAccount":
            MessageLookupByLibrary.simpleMessage("Already have an account?"),
        "alreadyUsedPromoCode": MessageLookupByLibrary.simpleMessage(
            "You have already used this promo code"),
        "anErrorOccurred":
            MessageLookupByLibrary.simpleMessage("An error occurred"),
        "appTitle": MessageLookupByLibrary.simpleMessage("Meals App"),
        "appVersion": MessageLookupByLibrary.simpleMessage("App Version"),
        "apply": MessageLookupByLibrary.simpleMessage("Apply"),
        "arabic": MessageLookupByLibrary.simpleMessage("العربية"),
        "areYouSureYouWantToDeleteThisAddress":
            MessageLookupByLibrary.simpleMessage(
                "Are you sure you want to delete this address?"),
        "area": MessageLookupByLibrary.simpleMessage("Area"),
        "areaHint":
            MessageLookupByLibrary.simpleMessage("Enter your area or district"),
        "areaLabel": MessageLookupByLibrary.simpleMessage("Area"),
        "aswan": MessageLookupByLibrary.simpleMessage("Aswan"),
        "asyut": MessageLookupByLibrary.simpleMessage("Asyut"),
        "beniSuef": MessageLookupByLibrary.simpleMessage("Beni Suef"),
        "beverage": MessageLookupByLibrary.simpleMessage("Beverage"),
        "browseMenu": MessageLookupByLibrary.simpleMessage("Browse Menu"),
        "cairo": MessageLookupByLibrary.simpleMessage("Cairo"),
        "callSupport": MessageLookupByLibrary.simpleMessage("Call support"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cart": MessageLookupByLibrary.simpleMessage("Cart"),
        "cashOnDelivery":
            MessageLookupByLibrary.simpleMessage("Cash on Delivery"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Change password"),
        "checkout": MessageLookupByLibrary.simpleMessage("Checkout"),
        "checkoutNotImplemented": MessageLookupByLibrary.simpleMessage(
            "Checkout functionality is not implemented yet"),
        "chickenFries": MessageLookupByLibrary.simpleMessage("Chicken Fries"),
        "cityLabel": MessageLookupByLibrary.simpleMessage("City"),
        "clearError": MessageLookupByLibrary.simpleMessage("Clear error"),
        "confirmDeleteAccount":
            MessageLookupByLibrary.simpleMessage("Confirm Account Deletion"),
        "confirmNewPassword":
            MessageLookupByLibrary.simpleMessage("Confirm new password"),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "connectionLost":
            MessageLookupByLibrary.simpleMessage("Connection lost"),
        "connectionRestored":
            MessageLookupByLibrary.simpleMessage("Connection restored"),
        "continueButton": MessageLookupByLibrary.simpleMessage("Continue"),
        "continueShopping":
            MessageLookupByLibrary.simpleMessage("Continue Shopping"),
        "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
        "createPassword":
            MessageLookupByLibrary.simpleMessage("Create Password"),
        "createPasswordForEmail": MessageLookupByLibrary.simpleMessage(
            "Create a password for your account"),
        "creditCard": MessageLookupByLibrary.simpleMessage("Credit Card"),
        "currentPassword":
            MessageLookupByLibrary.simpleMessage("Current password"),
        "dakahlia": MessageLookupByLibrary.simpleMessage("Dakahlia"),
        "damietta": MessageLookupByLibrary.simpleMessage("Damietta"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteAccountWarning": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete your account? This action cannot be undone."),
        "deleteAddress": MessageLookupByLibrary.simpleMessage("Delete Address"),
        "deleteMyAccount":
            MessageLookupByLibrary.simpleMessage("Delete My Account"),
        "delivery": MessageLookupByLibrary.simpleMessage("Delivery"),
        "deliveryAddress":
            MessageLookupByLibrary.simpleMessage("Delivery Address"),
        "deliveryFee": MessageLookupByLibrary.simpleMessage("Delivery Fee"),
        "deliveryFeeApplied":
            MessageLookupByLibrary.simpleMessage("50 EGP delivery fee applied"),
        "deliveryOption":
            MessageLookupByLibrary.simpleMessage("Delivery Option"),
        "deliveryTo": MessageLookupByLibrary.simpleMessage("Delivery to"),
        "deliveryType": MessageLookupByLibrary.simpleMessage("Delivery Type"),
        "detailedAddress": MessageLookupByLibrary.simpleMessage(
            "Area, Street, Building number"),
        "detailedAddressHint": MessageLookupByLibrary.simpleMessage(
            "Street, building, apartment, floor..."),
        "detailedAddressLabel":
            MessageLookupByLibrary.simpleMessage("Detailed Address"),
        "didntReceiveCode":
            MessageLookupByLibrary.simpleMessage("Didn\'t receive the code?"),
        "discount": MessageLookupByLibrary.simpleMessage("Discount"),
        "dontHaveAccount":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account?"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "editAddress": MessageLookupByLibrary.simpleMessage("Edit Address"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "emailAddress": MessageLookupByLibrary.simpleMessage("Email Address"),
        "emailExample":
            MessageLookupByLibrary.simpleMessage("meals@example.com"),
        "english": MessageLookupByLibrary.simpleMessage("English"),
        "enterNewPassword":
            MessageLookupByLibrary.simpleMessage("Enter new password"),
        "enterPromoCode":
            MessageLookupByLibrary.simpleMessage("Enter promo code"),
        "enterResetToken": MessageLookupByLibrary.simpleMessage(
            "Enter the reset token from your email"),
        "enterResetTokenInstructions": MessageLookupByLibrary.simpleMessage(
            "Please check your email for the reset token and enter it below along with your new password."),
        "enterYourArea":
            MessageLookupByLibrary.simpleMessage("Enter your area"),
        "enterYourEmail":
            MessageLookupByLibrary.simpleMessage("Enter your email"),
        "enterYourFullName":
            MessageLookupByLibrary.simpleMessage("Enter your full name"),
        "errorApplyingPromoCode":
            MessageLookupByLibrary.simpleMessage("Error applying promo code"),
        "errorGettingLocation":
            MessageLookupByLibrary.simpleMessage("Error getting location"),
        "errorLoadingMenuItems":
            MessageLookupByLibrary.simpleMessage("Error loading menu items"),
        "errorLoadingOffers":
            MessageLookupByLibrary.simpleMessage("Error loading offers"),
        "errorLoadingRecommendations": MessageLookupByLibrary.simpleMessage(
            "Error loading recommendations"),
        "extras": MessageLookupByLibrary.simpleMessage("Extras"),
        "failedToAddToCart":
            MessageLookupByLibrary.simpleMessage("Failed to add to cart"),
        "failedToCreateAddress":
            MessageLookupByLibrary.simpleMessage("Failed to create address"),
        "failedToDeleteAddress":
            MessageLookupByLibrary.simpleMessage("Failed to delete address"),
        "failedToGetLocation": m0,
        "failedToLoadAddresses":
            MessageLookupByLibrary.simpleMessage("Failed to load addresses"),
        "failedToLoadCart":
            MessageLookupByLibrary.simpleMessage("Failed to load cart"),
        "failedToPlaceOrder": MessageLookupByLibrary.simpleMessage(
            "Failed to place order. Please try again."),
        "failedToSaveAddress": m1,
        "failedToSetPrimaryAddress": MessageLookupByLibrary.simpleMessage(
            "Failed to set primary address"),
        "failedToUpdateAddress":
            MessageLookupByLibrary.simpleMessage("Failed to update address"),
        "faiyum": MessageLookupByLibrary.simpleMessage("Faiyum"),
        "feedback": MessageLookupByLibrary.simpleMessage("Feedback"),
        "feedbackSubmittedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Feedback submitted successfully!"),
        "foodDescription": MessageLookupByLibrary.simpleMessage(
            "Delicious chicken fries made with premium quality chicken, served with our special sauce."),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "formSubmittedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Form submitted successfully!"),
        "fullName": MessageLookupByLibrary.simpleMessage("Full name"),
        "getStarted": MessageLookupByLibrary.simpleMessage("GET STARTED"),
        "gharbia": MessageLookupByLibrary.simpleMessage("Gharbia"),
        "giza": MessageLookupByLibrary.simpleMessage("Giza"),
        "hello": m2,
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "hotDeals": MessageLookupByLibrary.simpleMessage("Hot Deals"),
        "hotDealsDescription": MessageLookupByLibrary.simpleMessage(
            "These items are available for a limited time only. Take advantage of these wonderful deals before it is too late. Try it now!"),
        "howEasyToMakeOrder": MessageLookupByLibrary.simpleMessage(
            "How easy was it to make your order from our website?"),
        "howSatisfiedAreYouWithFoodQuality":
            MessageLookupByLibrary.simpleMessage(
                "How satisfied are you with the quality of the food?"),
        "howSatisfiedAreYouWithServiceSpeed":
            MessageLookupByLibrary.simpleMessage(
                "How satisfied are you with the speed of the service?"),
        "howSatisfiedWithOverallService": MessageLookupByLibrary.simpleMessage(
            "How satisfied are you with the overall service?"),
        "invalidOrExpiredPromoCode": MessageLookupByLibrary.simpleMessage(
            "Invalid or expired promo code"),
        "invalidOtp": MessageLookupByLibrary.simpleMessage(
            "Invalid verification code. Please try again."),
        "ismailia": MessageLookupByLibrary.simpleMessage("Ismailia"),
        "item": MessageLookupByLibrary.simpleMessage("Item"),
        "items": MessageLookupByLibrary.simpleMessage("Items"),
        "kafrElSheikh": MessageLookupByLibrary.simpleMessage("Kafr El Sheikh"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "large": MessageLookupByLibrary.simpleMessage("Large"),
        "leaveUsFeedback":
            MessageLookupByLibrary.simpleMessage("Leave Us Feedback"),
        "letsSignYouUp":
            MessageLookupByLibrary.simpleMessage("Let\'s sign you up"),
        "location": MessageLookupByLibrary.simpleMessage("Location"),
        "locationAccessDescription": MessageLookupByLibrary.simpleMessage(
            "DFOOD WILL ACCESS YOUR LOCATION\nONLY WHILE USING THE APP"),
        "locationCapturedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Location Captured Successfully"),
        "locationPermissionDenied":
            MessageLookupByLibrary.simpleMessage("Location permission denied"),
        "locationPermissionPermanentlyDenied":
            MessageLookupByLibrary.simpleMessage(
                "Location permission permanently denied"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "loyaltyPoints": MessageLookupByLibrary.simpleMessage("Loyalty Points"),
        "luxor": MessageLookupByLibrary.simpleMessage("Luxor"),
        "markAsPrimary":
            MessageLookupByLibrary.simpleMessage("Mark as primary address"),
        "matrouh": MessageLookupByLibrary.simpleMessage("Matrouh"),
        "medium": MessageLookupByLibrary.simpleMessage("Medium"),
        "menu": MessageLookupByLibrary.simpleMessage("Menu"),
        "minya": MessageLookupByLibrary.simpleMessage("Minya"),
        "monufia": MessageLookupByLibrary.simpleMessage("Monufia"),
        "myCart": MessageLookupByLibrary.simpleMessage("My Cart"),
        "myOrders": MessageLookupByLibrary.simpleMessage("My orders"),
        "newPassword": MessageLookupByLibrary.simpleMessage("New password"),
        "newValley": MessageLookupByLibrary.simpleMessage("New Valley"),
        "next": MessageLookupByLibrary.simpleMessage("NEXT"),
        "noAddressesFound":
            MessageLookupByLibrary.simpleMessage("No Addresses Found"),
        "noDataAvailable":
            MessageLookupByLibrary.simpleMessage("No data available"),
        "noDeliveryAddressSelected": MessageLookupByLibrary.simpleMessage(
            "No delivery address selected"),
        "noExtrasAllowed": MessageLookupByLibrary.simpleMessage(
            "No extras are allowed as a special request."),
        "noInternetConnection": MessageLookupByLibrary.simpleMessage(
            "No internet connection. Please check your connection and try again."),
        "noMenuItemsAvailable":
            MessageLookupByLibrary.simpleMessage("No menu items available"),
        "noOffersAvailable":
            MessageLookupByLibrary.simpleMessage("No offers available"),
        "noPickupBranchSelected":
            MessageLookupByLibrary.simpleMessage("No pickup branch selected"),
        "noRecommendationsAvailable": MessageLookupByLibrary.simpleMessage(
            "No recommendations available"),
        "noSavedAddresses": MessageLookupByLibrary.simpleMessage(
            "You don\'t have any saved addresses"),
        "northSinai": MessageLookupByLibrary.simpleMessage("North Sinai"),
        "offers": MessageLookupByLibrary.simpleMessage("Offers"),
        "onboardingDesc1": MessageLookupByLibrary.simpleMessage(
            "Get all your loved foods in one place, you just place the order we do the rest"),
        "onboardingDesc2": MessageLookupByLibrary.simpleMessage(
            "Get all your loved foods in one place, you just place the order we do the rest"),
        "onboardingDesc3": MessageLookupByLibrary.simpleMessage(
            "Get all your loved foods in one place, you just place the order we do the rest"),
        "onboardingTitle1":
            MessageLookupByLibrary.simpleMessage("All your favorites"),
        "onboardingTitle2":
            MessageLookupByLibrary.simpleMessage("Order from chosen chef"),
        "onboardingTitle3":
            MessageLookupByLibrary.simpleMessage("Free delivery offers"),
        "optional": MessageLookupByLibrary.simpleMessage("Optional"),
        "order": MessageLookupByLibrary.simpleMessage("Order"),
        "orderID": MessageLookupByLibrary.simpleMessage("Order ID"),
        "orderPlacedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Order Placed Successfully"),
        "orderReadyNotificationBody": MessageLookupByLibrary.simpleMessage(
            "Your order will be ready in 30 mins"),
        "orderReadyNotificationTitle":
            MessageLookupByLibrary.simpleMessage("Order Confirmation"),
        "orderSummary": MessageLookupByLibrary.simpleMessage("Order Summary"),
        "orderType": MessageLookupByLibrary.simpleMessage("Order Type"),
        "otpResent": MessageLookupByLibrary.simpleMessage(
            "Verification code has been resent"),
        "otpSentToEmail": MessageLookupByLibrary.simpleMessage(
            "A 6-digit verification code has been sent to your email"),
        "overall": MessageLookupByLibrary.simpleMessage("Overall"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordMustBeAtLeast6": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 6 characters"),
        "passwordMustBeAtLeast8": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 8 characters"),
        "passwordResetEmailSent": MessageLookupByLibrary.simpleMessage(
            "Password reset email sent successfully!"),
        "passwordResetInstructions":
            MessageLookupByLibrary.simpleMessage("Password Reset Instructions"),
        "passwordResetSuccess": MessageLookupByLibrary.simpleMessage(
            "Password reset successfully!"),
        "passwordUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Password updated successfully!"),
        "passwordsDoNotMatch":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "paymentMethod": MessageLookupByLibrary.simpleMessage("Payment Method"),
        "personalDetails":
            MessageLookupByLibrary.simpleMessage("Personal Details"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
        "phoneNumberMustBeAtLeast11Digits":
            MessageLookupByLibrary.simpleMessage(
                "Phone number must be at least 11 digits"),
        "phoneNumberRequired": MessageLookupByLibrary.simpleMessage(
            "Please enter your phone number"),
        "pickup": MessageLookupByLibrary.simpleMessage("Pickup"),
        "pickupBranch": MessageLookupByLibrary.simpleMessage("Pickup Branch"),
        "pickupFromBranch": MessageLookupByLibrary.simpleMessage(
            "Pick up your order from selected branch"),
        "placeOrder": MessageLookupByLibrary.simpleMessage("Place Order"),
        "placingOrder":
            MessageLookupByLibrary.simpleMessage("Placing order..."),
        "pleaseConfirmPassword": MessageLookupByLibrary.simpleMessage(
            "Please confirm your password"),
        "pleaseEnterAddress": MessageLookupByLibrary.simpleMessage(
            "Please enter your detailed address"),
        "pleaseEnterArea":
            MessageLookupByLibrary.simpleMessage("Please enter your area"),
        "pleaseEnterPassword":
            MessageLookupByLibrary.simpleMessage("Please enter a password"),
        "pleaseEnterPromoCode":
            MessageLookupByLibrary.simpleMessage("Please enter a promo code"),
        "pleaseEnterValidEmail": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid email address"),
        "pleaseEnterYourEmail":
            MessageLookupByLibrary.simpleMessage("Please enter your email"),
        "pleaseEnterYourName":
            MessageLookupByLibrary.simpleMessage("Please enter your name"),
        "pleaseLoginToContinue":
            MessageLookupByLibrary.simpleMessage("Please login to continue"),
        "pleaseSelectAnAddress":
            MessageLookupByLibrary.simpleMessage("Please select an address"),
        "pleaseSelectDeliveryAddress": MessageLookupByLibrary.simpleMessage(
            "Please select a delivery address"),
        "pleaseSelectPickupBranch": MessageLookupByLibrary.simpleMessage(
            "Please select a pickup branch"),
        "pleaseSignInToAccessContent": MessageLookupByLibrary.simpleMessage(
            "Please sign in to access this content"),
        "portSaid": MessageLookupByLibrary.simpleMessage("Port Said"),
        "preferences": MessageLookupByLibrary.simpleMessage("Preferences"),
        "primary": MessageLookupByLibrary.simpleMessage("Primary"),
        "primaryAddress":
            MessageLookupByLibrary.simpleMessage("Primary Address"),
        "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
        "profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "promoCode": MessageLookupByLibrary.simpleMessage("Promo Code"),
        "qalyubia": MessageLookupByLibrary.simpleMessage("Qalyubia"),
        "qena": MessageLookupByLibrary.simpleMessage("Qena"),
        "rating": MessageLookupByLibrary.simpleMessage("Rating"),
        "recommended": MessageLookupByLibrary.simpleMessage("Recommended"),
        "recommendedDescription": MessageLookupByLibrary.simpleMessage(
            "Dishes our customers love the most. Try our most popular options that are sure to satisfy your cravings!"),
        "reconnecting": MessageLookupByLibrary.simpleMessage("Reconnecting..."),
        "redSea": MessageLookupByLibrary.simpleMessage("Red Sea"),
        "regular": MessageLookupByLibrary.simpleMessage("Regular"),
        "removePromoCode":
            MessageLookupByLibrary.simpleMessage("Remove promo code"),
        "resendCode": MessageLookupByLibrary.simpleMessage("Resend Code"),
        "resendCodeIn": MessageLookupByLibrary.simpleMessage("Resend code in"),
        "resendResetEmail":
            MessageLookupByLibrary.simpleMessage("Resend Reset Email"),
        "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
        "resetPasswordFor":
            MessageLookupByLibrary.simpleMessage("Reset password for"),
        "resetToken": MessageLookupByLibrary.simpleMessage("Reset Token"),
        "resetTokenRequired": MessageLookupByLibrary.simpleMessage(
            "Please enter the reset token"),
        "retryingConnection":
            MessageLookupByLibrary.simpleMessage("Retrying connection..."),
        "saveAddress": MessageLookupByLibrary.simpleMessage("Save Address"),
        "savedAddresses":
            MessageLookupByLibrary.simpleMessage("Saved Addresses"),
        "savedAddressesScreen":
            MessageLookupByLibrary.simpleMessage("Saved Addresses"),
        "seconds": MessageLookupByLibrary.simpleMessage("seconds"),
        "selectBranch": MessageLookupByLibrary.simpleMessage("Select Branch"),
        "selectDeliveryAddress": MessageLookupByLibrary.simpleMessage(
            "Please select a delivery address"),
        "selectPickupBranch": MessageLookupByLibrary.simpleMessage(
            "Please select a pickup branch"),
        "selectYourCity":
            MessageLookupByLibrary.simpleMessage("Select your city"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "sharqia": MessageLookupByLibrary.simpleMessage("Sharqia"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "size": MessageLookupByLibrary.simpleMessage("Size"),
        "skip": MessageLookupByLibrary.simpleMessage("Skip"),
        "sohag": MessageLookupByLibrary.simpleMessage("Sohag"),
        "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
            "Something went wrong. Please try again."),
        "southSinai": MessageLookupByLibrary.simpleMessage("South Sinai"),
        "specialRequests":
            MessageLookupByLibrary.simpleMessage("SPECIAL REQUESTS"),
        "streetAndBuilding":
            MessageLookupByLibrary.simpleMessage("Street & Building"),
        "streetAndBuildingHint": MessageLookupByLibrary.simpleMessage(
            "Street name and building number"),
        "subTotal": MessageLookupByLibrary.simpleMessage("Sub total"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "suez": MessageLookupByLibrary.simpleMessage("Suez"),
        "termsAndConditions":
            MessageLookupByLibrary.simpleMessage("Terms and conditions"),
        "thankYouForYourOrder":
            MessageLookupByLibrary.simpleMessage("Thank you for your order!"),
        "theRealThing": MessageLookupByLibrary.simpleMessage("The Real Thing."),
        "total": MessageLookupByLibrary.simpleMessage("Total"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Try Again"),
        "typeYourFeedback":
            MessageLookupByLibrary.simpleMessage("Type your feedback..."),
        "typeYourSpecialRequestsHere": MessageLookupByLibrary.simpleMessage(
            "Type your special requests here..."),
        "update": MessageLookupByLibrary.simpleMessage("Update"),
        "updateAddress": MessageLookupByLibrary.simpleMessage("Update Address"),
        "useCurrentLocation":
            MessageLookupByLibrary.simpleMessage("Use Current Location"),
        "userNotAuthenticated":
            MessageLookupByLibrary.simpleMessage("User not authenticated"),
        "vat": MessageLookupByLibrary.simpleMessage("VAT"),
        "verificationCode":
            MessageLookupByLibrary.simpleMessage("Verification Code"),
        "verificationCodeSent": MessageLookupByLibrary.simpleMessage(
            "Verification code has been sent to your mobile phone"),
        "verify": MessageLookupByLibrary.simpleMessage("Verify"),
        "viewCart": MessageLookupByLibrary.simpleMessage("View Cart"),
        "welcome":
            MessageLookupByLibrary.simpleMessage("Welcome to the Meals App"),
        "welcomeToMealsApp":
            MessageLookupByLibrary.simpleMessage("WELCOME TO MEALS APP"),
        "youCanTrackOrderStatus": MessageLookupByLibrary.simpleMessage(
            "You can track your order status in My Orders section"),
        "yourCartIsEmpty":
            MessageLookupByLibrary.simpleMessage("Your cart is empty"),
        "yourExactCoordinatesWereCaptured":
            MessageLookupByLibrary.simpleMessage(
                "Your exact coordinates were captured")
      };
}
