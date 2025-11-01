
<a href="https://github.com/drshahizan/mobile_apps/stargazers"><img src="https://img.shields.io/github/stars/drshahizan/mobile_apps" alt="Stars Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/network/members"><img src="https://img.shields.io/github/forks/drshahizan/mobile_apps" alt="Forks Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/pulls"><img src="https://img.shields.io/github/issues-pr/drshahizan/mobile_apps" alt="Pull Requests Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/issues"><img src="https://img.shields.io/github/issues/drshahizan/mobile_apps" alt="Issues Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/graphs/contributors"><img alt="GitHub contributors" src="https://img.shields.io/github/contributors/drshahizan/mobile_apps?color=2b9348"></a>
![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan%2Fmobile_apps&labelColor=%23d9e3f0&countColor=%23697689&style=flat)



# ✅ Step-by-Step: Using VS Code with Flutter

## A. Open or Create the Project

1. **Open an existing project (exercise1)**

* VS Code → **File → Open Folder…**
* Select your folder: `exercise1`

2. **(Alternative) Create a new Flutter project via Command Palette**

* Press **Ctrl+Shift+P** (Windows/Linux) or **Cmd+Shift+P** (macOS)
* Type **Flutter: New Project** → choose **Application**
* Pick a folder and name it (e.g., `exercise1`)
* Wait for VS Code to finish creating the project and fetching packages

> Tip: You only need one of the two options above—open an existing project OR create a new one.



## B. Pick/Start an Emulator

1. **Bottom-right device picker**

* Look at the **status bar (bottom right)** in VS Code
* Click the device selector and choose your Android AVD, e.g. **“Medium Phone API 36.1”**
* If it isn’t started yet, VS Code will launch it (or you can start it from Android Studio → **Device Manager**)

> If you don’t see any device, open Android Studio and create one (AVD). Then return to VS Code.



## C. Open the Terminal

* Press **Ctrl+`** (backtick/tilde key) to open the integrated **Terminal**

  * (macOS: **Cmd+`**)


## D. Run a Specific Dart Entry File

If your app’s main entry is **not** `lib/main.dart`, use **`-t`** (target) to point to a different file.

* Example (your file): `lib/01layoutSample.dart`

```bash
flutter run -t lib/01layoutSample.dart
```

> Your note said “flutter run lib/01layoutSample.dart”.
> The correct form is **`flutter run -t lib/01layoutSample.dart`**.



## E. Develop Efficiently (Hot Reload/Stop)

* **Hot Reload:** press **r** in the terminal (while the app is running)
* **Hot Restart:** press **R**
* **Stop the app:** press **Ctrl+C** in the terminal
* **Quit the Flutter tool:** press **q**



## F. Quick Keystroke Cheatsheet

* **Command Palette:** `Ctrl+Shift+P` (Win/Linux) | `Cmd+Shift+P` (macOS)
* **Open Terminal:** `Ctrl+`` (Win/Linux) | `Cmd+`` (macOS)
* **Run with target:** `flutter run -t <path-to-dart-file>`
* **Stop run:** `Ctrl+C`



## G. Common Gotchas

* **No device listed:** Start an AVD from Android Studio → Device Manager, then return to VS Code.
* **Build errors after file changes:**

  ```bash
  flutter clean
  flutter pub get
  ```
* **Multiple devices connected:**

  ```bash
  flutter devices
  flutter run -d <device_id> -t lib/01layoutSample.dart
  ```


## Contribution 🛠️
Please create an [Issue](https://github.com/drshahizan/mobile_apps/issues) for any improvements, suggestions or errors in the content.

You can also contact me using [Linkedin](https://www.linkedin.com/in/drshahizan/) for any other queries or feedback.

[![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan&labelColor=%23697689&countColor=%23555555&style=plastic)](https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fdrshahizan)
![](https://hit.yhype.me/github/profile?user_id=81284918)



