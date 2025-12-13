
<a href="https://github.com/drshahizan/mobile_apps/stargazers"><img src="https://img.shields.io/github/stars/drshahizan/mobile_apps" alt="Stars Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/network/members"><img src="https://img.shields.io/github/forks/drshahizan/mobile_apps" alt="Forks Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/pulls"><img src="https://img.shields.io/github/issues-pr/drshahizan/mobile_apps" alt="Pull Requests Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/issues"><img src="https://img.shields.io/github/issues/drshahizan/mobile_apps" alt="Issues Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/graphs/contributors"><img alt="GitHub contributors" src="https://img.shields.io/github/contributors/drshahizan/mobile_apps?color=2b9348"></a>
![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan%2Fmobile_apps&labelColor=%23d9e3f0&countColor=%23697689&style=flat)


# Starter Firestore Query Code: UTM Examination System (Flutter + Firestore)



## 1. Important Note for Students

Firestore databases are **created automatically** when:

* You create a Firebase project, and
* You add your **first document** (via console or code).

There is **no separate “create database” command**.

This starter code helps you:

* Insert **initial data** (once only)
* Read data safely for UI display



## 2. Create a Firestore Service File (Recommended)

Create a new file:

```
lib/services/firestore_service.dart
```



## 3. Firestore Service: Basic Setup

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
}
```

This class will contain **all Firestore logic**.



## 4. Starter Code: Insert Sample Data (Create Database Content)

⚠️ **Run this ONCE only** (for example, from a temporary button).



### 4.1 Add Sample Student Data

```dart
Future<void> addSampleStudent() async {
  await _db.collection('students').add({
    'name': 'Ahmad Firdaus',
    'matricNo': 'A22CS0012',
    'faculty': 'Faculty of Computing',
    'semester': 'Semester 5',
  });
}
```



### 4.2 Add Sample Examination Timetable Data

```dart
Future<void> addSampleExamTimetable() async {
  await _db.collection('exam_timetable').add({
    'courseCode': 'SECJ3104',
    'courseName': 'Application Development',
    'date': '2025-06-20',
    'time': '9:00 AM – 12:00 PM',
    'venue': 'N28 Examination Hall',
  });
}
```

(Add at least 3 documents manually or by repeating this function.)



### 4.3 Add Sample Examination Results

```dart
Future<void> addSampleExamResult() async {
  await _db.collection('exam_results').add({
    'courseCode': 'SECJ3104',
    'courseName': 'Application Development',
    'grade': 'A',
  });
}
```



### 4.4 Add Academic Status Data

```dart
Future<void> addAcademicStatus() async {
  await _db.collection('academic_status').add({
    'status': 'Pass',
    'standing': 'Good Standing',
    'remarks': 'Eligible to continue studies',
  });
}
```



### 4.5 Add Announcement Data

```dart
Future<void> addAnnouncement() async {
  await _db.collection('announcements').add({
    'title': 'Final Examination Schedule Released',
    'date': '2025-06-01',
    'description':
        'Students are advised to check their examination timetable via the system.',
  });
}
```



## 5. How to Trigger Data Creation (Temporary Button)

Example (for lecturer/demo use only):

```dart
ElevatedButton(
  onPressed: () async {
    final service = FirestoreService();
    await service.addSampleStudent();
    await service.addSampleExamTimetable();
    await service.addSampleExamResult();
    await service.addAcademicStatus();
    await service.addAnnouncement();
  },
  child: const Text('Insert Sample Firestore Data'),
);
```

✅ After running once, **REMOVE this button**.



## 6. Starter Code: Read Firestore Data (For UI Screens)



### 6.1 Read Student Data (Dashboard Screen)

```dart
Stream<QuerySnapshot> getStudents() {
  return _db.collection('students').snapshots();
}
```

Usage in UI:

```dart
StreamBuilder<QuerySnapshot>(
  stream: FirestoreService().getStudents(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const CircularProgressIndicator();
    }

    final student = snapshot.data!.docs.first;
    return Text(student['name']);
  },
);
```



### 6.2 Read Examination Timetable

```dart
Stream<QuerySnapshot> getExamTimetable() {
  return _db.collection('exam_timetable').snapshots();
}
```

Usage with `ListView.builder`:

```dart
ListView.builder(
  itemCount: snapshot.data!.docs.length,
  itemBuilder: (context, index) {
    final doc = snapshot.data!.docs[index];
    return ListTile(
      title: Text(doc['courseCode']),
      subtitle: Text(doc['courseName']),
      trailing: Text(doc['date']),
    );
  },
);
```



### 6.3 Read Examination Results

```dart
Stream<QuerySnapshot> getExamResults() {
  return _db.collection('exam_results').snapshots();
}
```



### 6.4 Read Academic Status

```dart
Stream<QuerySnapshot> getAcademicStatus() {
  return _db.collection('academic_status').snapshots();
}
```

Usage:

```dart
final statusDoc = snapshot.data!.docs.first;
Text(statusDoc['status']);
```



### 6.5 Read Announcements

```dart
Stream<QuerySnapshot> getAnnouncements() {
  return _db.collection('announcements').snapshots();
}
```



## 7. Firestore Security Rules (Development Only)

⚠️ **For lab purposes only**:

```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read: if true;
      allow write: if true;
    }
  }
}
```

❗ Explain to students that this is **NOT suitable for production**.


## 8. What Students Must Understand (Teaching Notes)

* Firestore collections are **created automatically**
* Documents are **JSON-like**
* `StreamBuilder` enables **real-time updates**
* Data modelling is critical for system scalability
* Security rules are essential in real systems




## Contribution 🛠️
Please create an [Issue](https://github.com/drshahizan/mobile_apps/issues) for any improvements, suggestions or errors in the content.

You can also contact me using [Linkedin](https://www.linkedin.com/in/drshahizan/) for any other queries or feedback.

[![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan&labelColor=%23697689&countColor=%23555555&style=plastic)](https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fdrshahizan)
![](https://hit.yhype.me/github/profile?user_id=81284918)
