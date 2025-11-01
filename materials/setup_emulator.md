
<a href="https://github.com/drshahizan/mobile_apps/stargazers"><img src="https://img.shields.io/github/stars/drshahizan/mobile_apps" alt="Stars Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/network/members"><img src="https://img.shields.io/github/forks/drshahizan/mobile_apps" alt="Forks Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/pulls"><img src="https://img.shields.io/github/issues-pr/drshahizan/mobile_apps" alt="Pull Requests Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/issues"><img src="https://img.shields.io/github/issues/drshahizan/mobile_apps" alt="Issues Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/graphs/contributors"><img alt="GitHub contributors" src="https://img.shields.io/github/contributors/drshahizan/mobile_apps?color=2b9348"></a>
![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan%2Fmobile_apps&labelColor=%23d9e3f0&countColor=%23697689&style=flat)

## 🧩 Flutter Emulator Installation & Setup Guide

For **Windows** and **macOS**

### 💻 **1. Android Emulator (for Windows & macOS)**

#### 🧰 Prerequisites

* Install **Android Studio** from:
  👉 [https://developer.android.com/studio](https://developer.android.com/studio)
* Ensure **Flutter SDK** is installed and added to your PATH.

#### ⚙️ Setup Steps

1. **Open Android Studio → More Actions → SDK Manager**

   * Go to **SDK Tools** tab.
   * Ensure the following are checked:

     * *Android Emulator*
     * *Android SDK Platform-Tools*
     * *Android SDK Build-Tools*

2. **Create a Virtual Device**

   * Go to **Device Manager → Create Device**.
   * Choose a device (e.g., Pixel 7).
   * Select a system image (preferably *x86_64* or *arm64-v8a*).
   * Click **Finish** to save.

3. **Run the Emulator**

   * Launch the device from **Device Manager**.
   * Verify using:

     ```bash
     flutter devices
     ```
   * You should see the emulator listed.


### 🪟 **2. Windows Desktop Runner**

#### 🧰 Prerequisites

* Ensure you are using **Windows 10 (Build 19041)** or later.
* Install **Visual Studio 2022** (Community edition is fine).
  👉 [https://visualstudio.microsoft.com/](https://visualstudio.microsoft.com/)

  * During setup, select **Desktop development with C++** workload.

#### ⚙️ Setup Steps

1. Enable desktop support:

   ```bash
   flutter config --enable-windows-desktop
   ```
2. Verify setup:

   ```bash
   flutter doctor
   ```
3. Run your app directly:

   ```bash
   flutter run -d windows
   ```

✅ You can now run and debug Flutter desktop apps on Windows without a mobile emulator.



### 🍎 **3. iOS Simulator (macOS only)**

#### 🧰 Prerequisites

* Install **Xcode** from the App Store or from:
  👉 [https://developer.apple.com/xcode/](https://developer.apple.com/xcode/)
* Install **Command Line Tools**:

  ```bash
  xcode-select --install
  ```

#### ⚙️ Setup Steps

1. Open the **Simulator**:

   * From Xcode: **Xcode → Open Developer Tool → Simulator**
2. Verify Flutter detects it:

   ```bash
   flutter devices
   ```
3. Run your app:

   ```bash
   flutter run -d ios
   ```

💡 Tip: You can switch between iPhone models using **Hardware → Device** in the Simulator menu.


### 🍏 **4. macOS Desktop Runner**

#### ⚙️ Setup Steps

1. Enable macOS desktop support:

   ```bash
   flutter config --enable-macos-desktop
   ```
2. Verify:

   ```bash
   flutter doctor
   ```
3. Run:

   ```bash
   flutter run -d macos
   ```

✅ This allows you to run Flutter apps directly as native macOS apps.



### 🧠 **Final Verification**

After setting up everything, run:

```bash
flutter doctor
```

✅ Ensure all components show a green checkmark (✔).
If you see warnings, follow the suggested fixes before running your first app.



## Contribution 🛠️
Please create an [Issue](https://github.com/drshahizan/mobile_apps/issues) for any improvements, suggestions or errors in the content.

You can also contact me using [Linkedin](https://www.linkedin.com/in/drshahizan/) for any other queries or feedback.

[![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan&labelColor=%23697689&countColor=%23555555&style=plastic)](https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fdrshahizan)
![](https://hit.yhype.me/github/profile?user_id=81284918)


