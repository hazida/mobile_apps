
<a href="https://github.com/drshahizan/mobile_apps/stargazers"><img src="https://img.shields.io/github/stars/drshahizan/mobile_apps" alt="Stars Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/network/members"><img src="https://img.shields.io/github/forks/drshahizan/mobile_apps" alt="Forks Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/pulls"><img src="https://img.shields.io/github/issues-pr/drshahizan/mobile_apps" alt="Pull Requests Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/issues"><img src="https://img.shields.io/github/issues/drshahizan/mobile_apps" alt="Issues Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/graphs/contributors"><img alt="GitHub contributors" src="https://img.shields.io/github/contributors/drshahizan/mobile_apps?color=2b9348"></a>
![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan%2Fmobile_apps&labelColor=%23d9e3f0&countColor=%23697689&style=flat)


# Lab Exercise 2: Implementing the UTM Examination System UI

### From Figma Design to Flutter (Dart) in Visual Studio Code (Runnable App)

## 1. Lab Overview

In this lab, students will convert the **UTM Examination System UI design** (created and exported to **Figma** in Lab Exercise 1) into a **runnable Flutter mobile application** using **Dart**. Students will implement multiple screens and basic navigation. No backend is required; use **dummy/static data**.

This lab focuses on:

* Translating UI designs into Flutter widgets
* Building multi-screen navigation
* Applying consistent styling based on the design
* Running the app in an emulator or on a physical device


## 2. Learning Outcomes

By the end of this lab, students will be able to:

1. Inspect a Figma design and identify UI components (text fields, buttons, cards, lists).
2. Create a Flutter project and implement screens using Dart.
3. Build navigation using Flutter routes.
4. Apply consistent styling (colors, fonts, spacing) across screens.
5. Run and test the mobile UI prototype in an emulator/device.


## 3. Tools and Requirements

### Required Software

* **Flutter SDK** installed
* **Dart SDK** (comes with Flutter)
* **Android Studio** (for Android emulator) OR a physical Android device
  *(iOS Simulator requires macOS + Xcode)*
* **Visual Studio Code**
* VS Code Extensions:

  * **Flutter**
  * **Dart**

### Required Design Input

* Figma file from Lab Exercise 1 (UTM Examination System UI)



## 4. Case Study: UTM Examination System (Screens Required)

Your Flutter app must include these screens:

1. **Login Screen**
2. **Dashboard Screen**
3. **Examination Timetable Screen**
4. **Examination Results Screen**
5. **Academic Status Screen**
6. **Announcements Screen**

All screens must follow a **formal university style**, using a **blue and white theme**.


## 5. Lab Tasks



## Task 1: Prepare the UI Reference from Figma

1. Open your Figma file.
2. For each screen, identify the main UI elements:

   * App bar title
   * Input fields
   * Buttons
   * Card sections
   * List items
3. Note the following from the design:

   * Primary color (blue tone)
   * Background color (white or light grey)
   * Common padding (e.g., 16px)
   * Typography sizes (title, subtitle, body text)

✅ Output for Task 1 (to include in submission):
A short bullet list summarizing the main components for each screen.



## Task 2: Create a New Flutter Project in VS Code

1. Open **Visual Studio Code**.
2. Open the terminal inside VS Code.
3. Create a Flutter project:

```bash
flutter create utm_exam_app
```

4. Open the project folder:

   * **File → Open Folder → utm_exam_app**

5. Run this command to ensure everything is OK:

```bash
flutter doctor
```

✅ Expected: Most checks should show green ticks. If there are issues, fix them before continuing.



## Task 3: Create the Project Folder Structure (Clean Layout)

Inside `lib/`, create the following folders:

```
lib/
├── main.dart
├── theme/
│   └── app_theme.dart
├── screens/
│   ├── login_screen.dart
│   ├── dashboard_screen.dart
│   ├── timetable_screen.dart
│   ├── results_screen.dart
│   ├── status_screen.dart
│   └── announcements_screen.dart
├── widgets/
│   ├── app_card.dart
│   └── menu_button.dart
└── data/
    └── dummy_data.dart
```



## Task 4: Implement App Theme (Blue & White Formal Style)

Create `lib/theme/app_theme.dart` and define:

* Primary color: Blue
* Background: White / light grey
* Card style: Rounded corners
* Consistent text styles

✅ Requirements:

* Use **ThemeData**
* Apply theme in `MaterialApp`



## Task 5: Configure Navigation Routes in main.dart

In `main.dart`, set up named routes:

* `/` → LoginScreen
* `/dashboard` → DashboardScreen
* `/timetable` → TimetableScreen
* `/results` → ResultsScreen
* `/status` → StatusScreen
* `/announcements` → AnnouncementsScreen

✅ Requirement:

* Use `Navigator.pushNamed()` for navigation.



## Task 6: Build the Login Screen (login_screen.dart)

### UI Requirements

* Title: “UTM Examination System”
* Text field: Matric Number
* Text field: Password (obscure text)
* Button: “Login”
* Small note text: “For registered students only” (optional)

### Functional Requirement (Simple Navigation Only)

* When user taps **Login**, navigate to Dashboard:

  * `Navigator.pushReplacementNamed(context, '/dashboard');`

⚠️ No real authentication is needed.



## Task 7: Build the Dashboard Screen (dashboard_screen.dart)

### UI Requirements

The dashboard must show:

* Student Name (dummy)
* Matric Number (dummy)
* Faculty (dummy)
* Semester (dummy)

Below that, include menu buttons/cards linking to:

* Examination Timetable
* Examination Results
* Academic Status
* Announcements

✅ Requirement:

* Each menu item must navigate to the correct screen using named routes.



## Task 8: Implement the Examination Timetable Screen (timetable_screen.dart)

### Data Requirements (Dummy Data)

Display a list of timetable items. Each item must include:

* Course Code
* Course Name
* Date
* Time
* Venue

✅ UI Requirement:

* Use a **ListView** with **Card** widgets.
* Use clean spacing and readable layout.



## Task 9: Implement the Examination Results Screen (results_screen.dart)

### Data Requirements (Dummy Data)

Each course result must include:

* Course Code
* Course Name
* Grade (e.g., A, B+, etc.)

At the bottom, show:

* Semester GPA (dummy)
* CGPA (dummy)

✅ UI Requirement:

* Use cards or a table-like layout.
* Make the GPA section visually separated.



## Task 10: Implement the Academic Status Screen (status_screen.dart)

### Display Requirements

Show:

* Academic Status: Pass / Fail (dummy: Pass)
* Standing: Good Standing / Probation (dummy)
* Notes: “Refer to faculty office for official verification.” (formal note)

✅ UI Requirement:

* Use an info-style card or container.



## Task 11: Implement Announcements Screen (announcements_screen.dart)

### Data Requirements (Dummy Data)

Each announcement must include:

* Title
* Date
* Short description

✅ UI Requirement:

* Display as a list of cards.
* Make the title bold and the date smaller.



## Task 12: Add Reusable Widgets (Optional but Recommended)

Create reusable widgets:

### `app_card.dart`

A standard card widget used across the app.

### `menu_button.dart`

A widget for dashboard menu buttons.

✅ Benefit:

* Cleaner code
* More consistent UI



## Task 13: Run the Flutter App

### Option A: Run on Emulator

1. Open **Android Studio**
2. Open **Device Manager**
3. Start an emulator

### Option B: Run on Physical Android Device

1. Enable Developer Options
2. Enable USB Debugging
3. Connect phone to laptop

### Run Command

In VS Code terminal:

```bash
flutter run
```

✅ Testing Checklist

* App launches successfully
* Login navigates to dashboard
* All menu buttons navigate correctly
* All screens display dummy data correctly
* UI looks consistent and professional



## 6. Student Deliverables

Submit the following:

1. **Flutter project folder** (zipped), excluding build folders if required by your lecturer
2. **Screenshots** of each screen (6 screenshots)
3. A short **implementation report (500–700 words)** including:

   * How you translated Figma components into Flutter widgets
   * How you implemented navigation
   * Challenges faced and how you solved them
4. Bullet list from Task 1 (Figma analysis)



## 7. Reflection Questions

1. Which Flutter widgets best represent your Figma components (and why)?
2. What changes would be needed to connect this app to a real backend?
3. How would you improve the UI for accessibility and mobile responsiveness?


## Contribution 🛠️
Please create an [Issue](https://github.com/drshahizan/mobile_apps/issues) for any improvements, suggestions or errors in the content.

You can also contact me using [Linkedin](https://www.linkedin.com/in/drshahizan/) for any other queries or feedback.

[![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan&labelColor=%23697689&countColor=%23555555&style=plastic)](https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fdrshahizan)
![](https://hit.yhype.me/github/profile?user_id=81284918)
