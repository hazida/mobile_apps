
<a href="https://github.com/drshahizan/mobile_apps/stargazers"><img src="https://img.shields.io/github/stars/drshahizan/mobile_apps" alt="Stars Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/network/members"><img src="https://img.shields.io/github/forks/drshahizan/mobile_apps" alt="Forks Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/pulls"><img src="https://img.shields.io/github/issues-pr/drshahizan/mobile_apps" alt="Pull Requests Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/issues"><img src="https://img.shields.io/github/issues/drshahizan/mobile_apps" alt="Issues Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/graphs/contributors"><img alt="GitHub contributors" src="https://img.shields.io/github/contributors/drshahizan/mobile_apps?color=2b9348"></a>
![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan%2Fmobile_apps&labelColor=%23d9e3f0&countColor=%23697689&style=flat)

# Lab Exercise 3: Revising and Improving a Flutter App Design

### Using GitHub Copilot in Visual Studio Code

## 1. Lab Overview

In this lab exercise, students will use **GitHub Copilot** in **Visual Studio Code** to **revise, refine, and improve** the existing **Flutter (Dart) UI implementation** of the **UTM Examination System** developed in **Lab Exercise 2**.

The focus of this lab is **AI-assisted code refinement**, **UI consistency**, and **code quality improvement**, not building new features or backend services.

## 2. Learning Outcomes

By the end of this lab, students will be able to:

1. Use GitHub Copilot effectively within VS Code for Flutter development.
2. Improve UI layout and readability using AI-assisted suggestions.
3. Refactor Flutter code for better structure and reusability.
4. Apply consistent design improvements across multiple screens.
5. Critically evaluate AI-generated code before applying it.

## 3. Tools and Requirements

### Required Software

* Flutter SDK
* Visual Studio Code
* GitHub Account
* GitHub Copilot subscription (student version is acceptable)

### VS Code Extensions

* Flutter
* Dart
* GitHub Copilot

### Prerequisite

* Completed **Lab Exercise 2**
* A working Flutter app with all required screens implemented

## 4. Case Study Recap: UTM Examination System

The application includes the following screens:

1. Login
2. Dashboard
3. Examination Timetable
4. Examination Results
5. Academic Status
6. Announcements

Students will **revise the existing UI**, not redesign from scratch.

## 5. Lab Tasks

## Task 1: Enable GitHub Copilot in VS Code

1. Open **Visual Studio Code**.
2. Sign in to your **GitHub account**.
3. Ensure **GitHub Copilot** is enabled:

   * Open Command Palette (`Ctrl + Shift + P`)
   * Search for **Copilot: Enable**

✅ Verify Copilot is active by opening any Dart file and typing a comment.

## Task 2: Identify Design Issues to Improve

Review your Flutter app from Lab Exercise 2 and identify **at least three UI or code issues**, such as:

* Inconsistent padding or spacing
* Repeated widget code
* Hard-to-read layouts
* Poor alignment
* Overly long build methods

Document the issues before making changes.

## Task 3: Improve Theme Consistency Using Copilot

Open `app_theme.dart`.

### Instruction to Copilot (Example Comment)

```dart
// Improve this theme to make the app look more formal and consistent for a university examination system.
// Use blue and white colors, better typography, and consistent card styling.
```

Allow Copilot to suggest improvements such as:

* Better `TextTheme`
* Card elevation and shape
* Consistent button styles

✅ Apply changes **only after reviewing** Copilot’s suggestion.

## Task 4: Refactor Repeated UI Code into Reusable Widgets

Identify repeated UI patterns, such as:

* Information cards
* List item layouts
* Section headers

### Example Copilot Prompt

```dart
// Refactor this repeated card layout into a reusable Flutter widget
```

Create or improve widgets in:

* `widgets/app_card.dart`
* `widgets/menu_button.dart`

✅ Replace duplicated code in multiple screens with reusable widgets.



## Task 5: Improve Dashboard Layout with Copilot

Open `dashboard_screen.dart`.

### Copilot Instruction

```dart
// Improve the dashboard layout to be more structured and professional.
// Use GridView or well-spaced Column layout suitable for a university system.
```

Expected improvements:

* Better spacing
* Clear visual hierarchy
* Balanced layout

## Task 6: Enhance Readability of Examination Screens

Apply Copilot to improve:

* Timetable list layout
* Results card structure
* Status information presentation

### Example Comment

```dart
// Improve readability and alignment of this ListView for examination information.
// Make it clean and easy to scan.
```

Ensure:

* Labels and values are clearly separated
* Important information stands out
* UI remains simple and academic

## Task 7: Improve Navigation Code Quality

Open `main.dart` or navigation-related files.

### Copilot Instruction

```dart
// Improve route management for cleaner navigation and better readability
```

Possible improvements:

* Cleaner route definitions
* Consistent naming
* Reduced boilerplate

## Task 8: Validate and Test the Revised App

1. Run the app:

```bash
flutter run
```

2. Test:

   * Navigation flow
   * UI consistency
   * No layout overflow
   * No runtime errors

⚠️ Fix any issues introduced by Copilot.



## 6. Student Deliverables

Students must submit:

1. Updated Flutter project (zipped)
2. **Before-and-after screenshots** (at least two screens)
3. A short **reflection report (400–600 words)** covering:

   * Which parts were improved using Copilot
   * Which suggestions were accepted or rejected
   * How Copilot helped or did not help
4. A list of **Copilot prompts used** during the lab



## 7. Reflection Questions

1. Which Copilot suggestions were most useful?
2. Did Copilot ever suggest inappropriate or incorrect code?
3. Why is human review still necessary when using AI tools?
4. How does AI-assisted development affect productivity?



## 8. Conclusion

This lab introduces students to **AI-assisted software refinement**, demonstrating how tools like **GitHub Copilot** can support developers in improving **UI quality, consistency, and code structure**. Students also learn the importance of **critical evaluation** when working with AI-generated code.


## Contribution 🛠️
Please create an [Issue](https://github.com/drshahizan/mobile_apps/issues) for any improvements, suggestions or errors in the content.

You can also contact me using [Linkedin](https://www.linkedin.com/in/drshahizan/) for any other queries or feedback.

[![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan&labelColor=%23697689&countColor=%23555555&style=plastic)](https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fdrshahizan)
![](https://hit.yhype.me/github/profile?user_id=81284918)
