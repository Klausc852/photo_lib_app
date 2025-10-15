### Installation

1. **Clone or copy this project structure**

2. **Install dependencies:**
```bash
cd photo_lib_app/Photo_Lib/  
cp .env.example .env
flutter pub get
```

3. **Run build_runner (for Hive):**
```bash
flutter pub run build_runner build
```

4. **Run the app:**
```bash
flutter run
```

**Build the app for Android testing using apk**
```bash
flutter build apk --debug
```
**Locate and Install the Debug APK on Your Phone**

1. **Locate the APK:**
    After building the debug APK, you can find it in the following directory:
    ```
    photo_lib_app/build/app/outputs/flutter-apk/app-debug.apk
    ```

2. **Install the APK on Your Phone:**
    - Transfer the `app-debug.apk` file to your phone via USB, email, or any file-sharing method.
    - On your phone, navigate to the file location and tap on the APK file to install it.
    - If prompted, enable the option to install apps from unknown sources.

### App Features

- Implement light and dark themes with SafeArea. Lock rotation to portrait mode for mobile devices, as horizontal orientation is not ideal for enlarging photos and viewing details. Allow rotation for tablets.

- Fetch photo data from an API and display it to the user.

- Ensure the fetched photo data is not version-controlled and always stays up-to-date. The app should not cache the photo list response but use a package to cache the images.

- Allow sorting of photos in ascending or descending order by creation time.

- Provide filtering options based on description, creator, and location keywords.
