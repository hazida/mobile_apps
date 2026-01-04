
<a href="https://github.com/drshahizan/mobile_apps/stargazers"><img src="https://img.shields.io/github/stars/drshahizan/mobile_apps" alt="Stars Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/network/members"><img src="https://img.shields.io/github/forks/drshahizan/mobile_apps" alt="Forks Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/pulls"><img src="https://img.shields.io/github/issues-pr/drshahizan/mobile_apps" alt="Pull Requests Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/issues"><img src="https://img.shields.io/github/issues/drshahizan/mobile_apps" alt="Issues Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/graphs/contributors"><img alt="GitHub contributors" src="https://img.shields.io/github/contributors/drshahizan/mobile_apps?color=2b9348"></a>
![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan%2Fmobile_apps&labelColor=%23d9e3f0&countColor=%23697689&style=flat)

# 

# **SECTION B: STRUCTURED QUESTIONS**

**Instruction:** Answer **ALL questions**. The marks for each question are as indicated.



## **Question 1: Dart Basics & Class Functions (20 marks)**

A Flutter application is being developed to manage **library books**.

a. Given the incomplete Dart class below, complete the code by:

* declaring the missing attributes
* completing the constructor
* completing the `displayBook()` method

```dart
class Book {
  // declare attributes here

  Book(/* complete constructor */);

  void displayBook() {
    // print book information here
  }
}
```

(12 marks)

b. Explain how **null safety** in Dart helps prevent runtime errors in the `Book` class above.
(4 marks)

c. Rewrite one attribute in the `Book` class using the `final` keyword and explain why `final` is suitable in this case.
(4 marks)



## **Question 2: Flutter Widgets & Layout (20 marks)**

You are required to design a **user profile screen**.

a. Given the Flutter widget code below, identify whether it should be implemented as a `StatelessWidget` or `StatefulWidget`. Justify your answer.

```dart
class ProfileScreen extends Widget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Column(
        children: [
          Icon(Icons.person),
          Text("User Name")
        ],
      ),
    );
  }
}
```

(6 marks)

b. Draw a **widget tree diagram** based on the code above.
(6 marks)

c. Rewrite the code in part (a) using the **correct widget type** and include proper Flutter syntax.
(8 marks)



## **Question 3: Navigation in Flutter (20 marks)**

An **online course application** contains the following screens:

* IntroScreen
* LoginScreen
* CourseDashboard

a. Explain the effect of each navigation statement below.

```dart
Navigator.push(context,
  MaterialPageRoute(builder: (_) => LoginScreen()));
```

```dart
Navigator.pushReplacement(context,
  MaterialPageRoute(builder: (_) => CourseDashboard()));
```

(8 marks)

b. Modify the following code so that users **cannot navigate back** to the `LoginScreen` after successful login.

```dart
Navigator.push(context,
  MaterialPageRoute(builder: (_) => CourseDashboard()));
```

(6 marks)

c. Draw a **navigation flow diagram** that represents the navigation logic implemented above.
(6 marks)



## **Question 4: Dependency Injection (DI) (20 marks)**

A Flutter application retrieves **weather information** using a `WeatherService`.

a. Given the code below, identify the **Dependency Injection approach** used.

```dart
class WeatherScreen extends StatelessWidget {
  final WeatherService service;

  WeatherScreen(this.service);
}
```

(4 marks)

b. Rewrite the code above to demonstrate **Constructor Dependency Injection** clearly, including a short explanation.
(6 marks)

c. The code below uses `of(context)`:

```dart
final theme = Theme.of(context);
```

Explain how this statement relates to **InheritedWidget Dependency Injection**.
(5 marks)

d. Write a short code snippet showing how a **Service Locator** could be used to obtain `WeatherService`.
(5 marks)



## **Question 5: MVVM Architecture (20 marks)**

A Flutter application is developed for **task management**.

a. Identify which part of the MVVM architecture the following class represents and justify your answer.

```dart
class TaskViewModel extends ChangeNotifier {
  List<String> tasks = [];

  void addTask(String task) {
    tasks.add(task);
    notifyListeners();
  }
}
```

(6 marks)

b. Write a short Flutter widget code snippet that represents the **View** consuming the `TaskViewModel`.
(8 marks)

c. Explain how the **Model**, **View**, and **ViewModel** interact in the task management application above.
(6 marks)



## **Question 6: State Management (Provider) (20 marks)**

A shopping cart feature is implemented using Provider.

a. Explain the purpose of `notifyListeners()` in the following code.

```dart
class CartProvider extends ChangeNotifier {
  int itemCount = 0;

  void addItem() {
    itemCount++;
    notifyListeners();
  }
}
```

(5 marks)

b. Write the Flutter code required to **provide** `CartProvider` to the widget tree.
(5 marks)

c. Complete the code below so that the UI updates automatically when `itemCount` changes.

```dart
Consumer<CartProvider>(
  builder: (context, cart, child) {
    return Text(
      // complete this line
    );
  },
);
```

(6 marks)

d. Explain why `Provider.of<CartProvider>(context, listen: false)` might be used when calling `addItem()`.
(4 marks)



## **Question 7: Networking & JSON (20 marks)**

A Flutter application retrieves **product data** from an API.

a. Explain why the function below uses `async` and `await`.

```dart
Future<void> fetchProducts() async {
  final response = await http.get(Uri.parse(url));
}
```

(6 marks)

b. Given the JSON data below, write a Dart `Product` class with a `fromJson()` constructor.

```json
{
  "id": 101,
  "name": "Laptop",
  "price": 3500
}
```

(8 marks)

c. Write a `toJson()` method for the `Product` class.
(6 marks)



## **Question 8: Firebase Integration (20 marks)**

A mobile application stores **student attendance** records in Firebase.

a. Explain the purpose of the following Firebase initialization code.

```dart
await Firebase.initializeApp();
```

(4 marks)

b. Write a code snippet to **add attendance data** to a Firestore collection named `attendance`.
(6 marks)

c. Explain the difference between the following two Firestore operations.

```dart
FirebaseFirestore.instance.collection("attendance").get();
```

```dart
FirebaseFirestore.instance.collection("attendance").snapshots();
```

(6 marks)

d. Explain how **Firebase security rules** help protect attendance records.
(4 marks)




## Contribution 🛠️
Please create an [Issue](https://github.com/drshahizan/mobile_apps/issues) for any improvements, suggestions or errors in the content.

You can also contact me using [Linkedin](https://www.linkedin.com/in/drshahizan/) for any other queries or feedback.

[![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan&labelColor=%23697689&countColor=%23555555&style=plastic)](https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fdrshahizan)
![](https://hit.yhype.me/github/profile?user_id=81284918)





