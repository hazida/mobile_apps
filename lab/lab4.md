
<a href="https://github.com/drshahizan/mobile_apps/stargazers"><img src="https://img.shields.io/github/stars/drshahizan/mobile_apps" alt="Stars Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/network/members"><img src="https://img.shields.io/github/forks/drshahizan/mobile_apps" alt="Forks Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/pulls"><img src="https://img.shields.io/github/issues-pr/drshahizan/mobile_apps" alt="Pull Requests Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/issues"><img src="https://img.shields.io/github/issues/drshahizan/mobile_apps" alt="Issues Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/graphs/contributors"><img alt="GitHub contributors" src="https://img.shields.io/github/contributors/drshahizan/mobile_apps?color=2b9348"></a>
![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan%2Fmobile_apps&labelColor=%23d9e3f0&countColor=%23697689&style=flat)




# Lab Exercise 4: Integrating Firestore Database with a Flutter App

## 1. Lab Overview

In this lab exercise, students will integrate **Firebase Firestore** into their existing **Flutter mobile application** for the **UTM Examination System**. Students will design Firestore collections, insert sample data, and retrieve data dynamically to be displayed in the application.

This lab focuses on:

* Cloud database concepts
* Firestore data modelling
* Flutter–Firestore integration
* Reading data in real time

⚠️ This lab focuses on **READ operations only** (no update or delete).



## 2. Learning Outcomes

By the end of this lab, students will be able to:

1. Explain the role of Firestore in a mobile application.
2. Design Firestore collections and documents for an academic system.
3. Connect a Flutter app to Firebase Firestore.
4. Retrieve and display Firestore data in Flutter UI.
5. Replace dummy data with real cloud-based data.



## 3. Tools and Requirements

### Required Software

* Flutter SDK
* Visual Studio Code
* Firebase Account (Google account)
* Android Emulator or Physical Android Device

### Flutter Packages

* `firebase_core`
* `cloud_firestore`



## 4. Case Study Data Scope: UTM Examination System

The Firestore database will store data for:

* Students
* Examination timetable
* Examination results
* Academic status
* Announcements

Each screen in the Flutter app will retrieve data from **Firestore collections**.



## 5. Lab Tasks



## Task 1: Create a Firebase Project

1. Go to **[https://console.firebase.google.com/](https://console.firebase.google.com/)**
2. Click **Add Project**
3. Project Name:
   **utm-examination-system**
4. Disable Google Analytics (optional)
5. Click **Create Project**



## Task 2: Add Firebase to Flutter App (Android)

1. In Firebase Console, click **Add App → Android**
2. Android package name:

   ```
   com.example.utm_exam_app
   ```
3. Download `google-services.json`
4. Place it in:

   ```
   android/app/
   ```
5. Follow Firebase instructions to:

   * Update `build.gradle` files
   * Apply Google services plugin



## Task 3: Add Firebase Dependencies

Open `pubspec.yaml` and add:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.0.0
  cloud_firestore: ^4.0.0
```

Run:

```bash
flutter pub get
```



## Task 4: Initialize Firebase in Flutter

Modify `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

Import:

```dart
import 'package:firebase_core/firebase_core.dart';
```



## Task 5: Design Firestore Database Structure

Create the following **collections** in Firestore:

### 1️⃣ students

```json
{
  "name": "Ahmad Firdaus",
  "matricNo": "A22CS0012",
  "faculty": "Faculty of Computing",
  "semester": "Semester 5"
}
```



### 2️⃣ exam_timetable

```json
{
  "courseCode": "SECJ3104",
  "courseName": "Application Development",
  "date": "2025-06-20",
  "time": "9:00 AM – 12:00 PM",
  "venue": "N28 Examination Hall"
}
```



### 3️⃣ exam_results

```json
{
  "courseCode": "SECJ3104",
  "courseName": "Application Development",
  "grade": "A"
}
```



### 4️⃣ academic_status

```json
{
  "status": "Pass",
  "standing": "Good Standing",
  "remarks": "Eligible to continue studies"
}
```



### 5️⃣ announcements

```json
{
  "title": "Final Examination Schedule Released",
  "date": "2025-06-01",
  "description": "Students are advised to check their examination timetable via the system."
}
```

📌 Insert **at least 3 documents** for timetable, results, and announcements.



## Task 6: Retrieve Student Data from Firestore

Modify `dashboard_screen.dart` to:

* Query `students` collection
* Display:

  * Name
  * Matric Number
  * Faculty
  * Semester

Use `StreamBuilder` or `FutureBuilder`.

✅ Requirement:

* Data must come from Firestore, not hardcoded.



## Task 7: Display Examination Timetable from Firestore

In `timetable_screen.dart`:

* Query `exam_timetable`
* Display using `ListView.builder`
* Each document displayed inside a Card



## Task 8: Display Examination Results from Firestore

In `results_screen.dart`:

* Query `exam_results`
* Display:

  * Course code
  * Course name
  * Grade
* Display GPA as static text (calculation optional)



## Task 9: Display Academic Status from Firestore

In `status_screen.dart`:

* Query `academic_status`
* Display:

  * Status
  * Standing
  * Remarks



## Task 10: Display Announcements from Firestore

In `announcements_screen.dart`:

* Query `announcements`
* Display as a scrollable list
* Sort by date (optional)



## Task 11: Test the Application

Run:

```bash
flutter run
```

Testing checklist:

* App launches successfully
* Firestore data loads correctly
* No red screen or runtime error
* Internet connection required


## 6. Student Deliverables

Students must submit:

1. Flutter project (zipped)
2. Screenshots of Firestore collections
3. Screenshots of app screens showing Firestore data
4. A **short report (500–700 words)** covering:

   * Firestore data design
   * How Flutter retrieves data
   * Challenges faced during integration


## 7. Reflection Questions

1. Why is Firestore suitable for mobile applications?
2. What are the advantages of real-time data?
3. What security rules would be required for a real university system?
4. How would authentication change this design?


## 8. Conclusion

This lab introduces students to **cloud-based database integration** using **Firestore**, completing the transition from **UI design → Flutter implementation → AI-assisted refinement → real-time data integration**. The exercise reflects real-world mobile application development practices used in academic systems.


## Contribution 🛠️
Please create an [Issue](https://github.com/drshahizan/mobile_apps/issues) for any improvements, suggestions or errors in the content.

You can also contact me using [Linkedin](https://www.linkedin.com/in/drshahizan/) for any other queries or feedback.

[![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan&labelColor=%23697689&countColor=%23555555&style=plastic)](https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fdrshahizan)
![](https://hit.yhype.me/github/profile?user_id=81284918)
