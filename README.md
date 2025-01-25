E-Commerce Flutter App with Firebase Authentication ---->

This document provides a step-by-step guide to set up and run the e-commerce Flutter application integrated with Firebase Authentication.

Prerequisites ---->

1. Tools and Accounts Needed
Flutter SDK (Latest stable version)
Android Studio or Visual Studio Code
Firebase Account
Node.js (for Firebase CLI, optional for advanced setup)


2. Install Flutter SDK ---->
Follow the official guide: Flutter Installation Guide


3. Install Dependencies ---->
Ensure you have the following installed:
Android Studio / Xcode for device emulators
Dart and Flutter plugins in your IDE
An emulator or physical device for testing


Setup Instructions ---->
Step 1: Clone the Repository
Clone this repository using Git:
git clone <https://github.com/sarvjit07/E-commerce-Mitt-Arv.git
cd <ecommerce_app


Step 2: Install Flutter Dependencies ---->
Run the following commands to install dependencies:
flutter pub get
Firebase Setup


Step 3: Create a Firebase Project ---->
Go to the Firebase Console.
Click on Add Project and follow the on-screen instructions.


Step 4: Add Firebase to Your App ---->
For Android:
Register the app with your Android package name (found in android/app/src/main/AndroidManifest.xml).
Download the google-services.json file and place it in the android/app directory.


For iOS: ---->
Register the app with your iOS bundle identifier (found in ios/Runner.xcodeproj).
Download the GoogleService-Info.plist file and place it in the ios/Runner directory.
Open Podfile in the ios folder and ensure Firebase dependencies are added:


platform :ios, '12.0'

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  pod 'Firebase/Auth'
  pod 'Firebase/Core'
end


Run:
cd ios
pod install
cd ..



Step 5: Enable Firebase Authentication  ---->
In the Firebase Console, navigate to Authentication > Sign-in method.
Enable the Email/Password sign-in provider.
Running the Application



Step 6: Initialize Firebase ---->
Ensure the main.dart file initializes Firebase as shown below:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}



Step 7: Run the App ---->
Run the application with the following command:
flutter run



Step 8: Test the App ---->
Use the Register Screen to create a new account.
Login with the registered credentials.
Verify redirection to the Home Screen upon successful login.



Important Files ---->
main.dart 
<Handles the app initialization and Firebase configuration.>

login_screen.dart ---->
<Implements the login functionality.

register_screen.dart ---->
<Implements the user registration functionality.

auth_provider.dart ---->
<Manages authentication state and logic using ChangeNotifier.



Troubleshooting ---->
Common Errors
firebase_auth/configuration-not-found:
Ensure google-services.json or GoogleService-Info.plist is correctly placed.
Verify that Firebase is properly initialized in main.dart.


Pod Install Errors (iOS): ---->
Run pod install inside the ios directory.
Ensure CocoaPods is installed (sudo gem install cocoapods).
App not connecting to Firebase:
Check the internet connection.
Verify Firebase configuration in the console matches the app.



Features ---->
Firebase Authentication:
Register users with email and password.
Login functionality.
State Management:
Uses Provider for managing app state.



UI Enhancements: ---->
Responsive design with card-based login and register screens.



Future Enhancements ---->
Add Google and Facebook login providers.
Implement user profile and password reset features.
Add support for push notifications using Firebase Cloud Messaging (FCM).



For any questions or issues, feel free to contact [sarvjit1309@gmail.com].

