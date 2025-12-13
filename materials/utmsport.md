<a href="https://github.com/drshahizan/mobile_apps/stargazers"><img src="https://img.shields.io/github/stars/drshahizan/mobile_apps" alt="Stars Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/network/members"><img src="https://img.shields.io/github/forks/drshahizan/mobile_apps" alt="Forks Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/pulls"><img src="https://img.shields.io/github/issues-pr/drshahizan/mobile_apps" alt="Pull Requests Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/issues"><img src="https://img.shields.io/github/issues/drshahizan/mobile_apps" alt="Issues Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/graphs/contributors"><img alt="GitHub contributors" src="https://img.shields.io/github/contributors/drshahizan/mobile_apps?color=2b9348"></a>
![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan%2Fmobile_apps&labelColor=%23d9e3f0&countColor=%23697689&style=flat)

# **UTM Mobile Sports Hall Booking App**

**Step-by-Step Guide to Running the Application**

## **1. Firestore – Firebase Console**

1. Navigate to the Firebase Console at:
   **[https://console.firebase.google.com/](https://console.firebase.google.com/)**
   This platform is used to manage Firebase services, including Firestore.

2. Locate the project named **dartmaster** and verify that you have access to it.
   This confirms that you are working within the correct Firebase project.

3. Open **Firestore Database** and review the database named **booking**.
   This database is used by the UTM Mobile Sports Hall Booking App for data storage and retrieval.

4. Verify that the **booking** database contains the following collections:

   * **bookings**: stores records related to sports hall bookings.
   * **event**: stores event-related information used by the application.
   * **users**: stores user account information for authentication and authorization.

## **2. Flutter Project Setup**

1. Download and extract the file `utmsport.zip` from the following link:
   [https://liveutm-my.sharepoint.com/:u:/g/personal/shahizan_live_utm_my/IQDndLdM3cTJQIWaf7HsW8p3AcDFtqr7UduSmN0fSZjMNmg?e=jjFxr9](https://liveutm-my.sharepoint.com/:u:/g/personal/shahizan_live_utm_my/IQDndLdM3cTJQIWaf7HsW8p3AcDFtqr7UduSmN0fSZjMNmg?e=jjFxr9)
   This step prepares the Flutter project files required to run the application.

2. Open the extracted project folder using **VS Code**.
   This ensures the project is loaded correctly for development and execution.

## **3. Emulator Setup in VS Code**

1. In VS Code, activate the Android emulator.
   The emulator provides a virtual Android device for testing and running the application.

2. Select the emulator named **Medium Phone API 36.1**.
   This ensures the application runs using the specified device profile and Android API level.

## **4. Running the Application**

1. In VS Code, open the main application entry file:

   ```
   lib/main.dart
   ```

   This file serves as the starting point of the Flutter application.

2. Run the application using the following command:

   ```
   flutter run lib/main.dart
   ```

   This command builds the application and deploys it to the active emulator.

## **5. Login Credentials for Testing**

Use the following credentials to access the application during testing:

* **Academic User**

  * Username: `acad@gmail.com`
  * Password: `acad123`

* **Administrator**

  * Username: `admin@utm.my`
  * Password: `admin123`

These credentials allow you to log in and test different user roles within the UTM Mobile Sports Hall Booking App.


## Contribution 🛠️
Please create an [Issue](https://github.com/drshahizan/mobile_apps/issues) for any improvements, suggestions or errors in the content.

You can also contact me using [Linkedin](https://www.linkedin.com/in/drshahizan/) for any other queries or feedback.

[![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan&labelColor=%23697689&countColor=%23555555&style=plastic)](https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fdrshahizan)
![](https://hit.yhype.me/github/profile?user_id=81284918)

   This command builds the Flutter application and deploys it to the active emulator (**Medium Phone API 36.1**) for execution.
