# CMC Shuttle App System

This repository contains two apps:

1. CMC Shuttle App (for students)
2. CMC Shuttle Driver App (for drivers)

These apps work together to help Claremont McKenna College students and drivers coordinate shuttle services between campus and Alexan Kendry.

## Prerequisites

Before you can build and run these apps, you need to provide your own API keys for Google Maps and configure Firebase.

### Google Maps API Keys

You need to add your Google Maps API keys to the following files:

#### For Android

Place your API key in the `android/app/src/main/AndroidManifest.xml` file for both apps:

```
<meta-data
 android:name="com.google.android.geo.API_KEY"
 android:value="YOUR_API_KEY_HERE" />
 ```
 
#### For iOS

Place your API key in the `ios/Runner/AppDelegate.swift` file for both apps:

```swift
GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
```

### Firebase Configuration
You need to configure Firebase for both apps. First, create a Firebase project and add two apps (one for the student app and one for the driver app). Download the `GoogleService-Info.plist` (for iOS) and `google-services.json` (for Android) files for each app from the Firebase console.

Place these files in the appropriate directories:

For Android, place the `google-services.json` file in the android/app/ directory for both apps.
For iOS, place the `GoogleService-Info.plist` file in the ios/Runner/ directory for both apps.
Next, update the `lib/firebase_options.dart` file for both apps with the required information from your Firebase project:

```
final FirebaseOptions firebaseOptions = const FirebaseOptions(
  apiKey: 'YOUR_API_KEY_HERE',
  authDomain: 'YOUR_AUTH_DOMAIN_HERE',
  projectId: 'YOUR_PROJECT_ID_HERE',
  storageBucket: 'YOUR_STORAGE_BUCKET_HERE',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID_HERE',
  appId: 'YOUR_APP_ID_HERE',
);
```

## Building and Running the Apps
With the API keys and Firebase configuration in place, you can now build and run the apps on your devices or emulators.

For more information on building and running Flutter apps, please visit the official Flutter documentation:

* Flutter: Build and release for Android

* Flutter: Build and release for iOS

## Contributing
Please submit any issues or pull requests through GitHub. We welcome any contributions and feedback. Thank you!
