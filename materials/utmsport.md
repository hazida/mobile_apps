# **Step-by-Step Guide to Running the UTMSport Mobile Application**

## **1. Firestore – Firebase Console**

1. Navigate to the Firebase Console at:
   **[https://console.firebase.google.com/](https://console.firebase.google.com/)**
   This is the official portal used to manage Firebase services, including Firestore databases.

2. Locate the project named **dartmaster** and confirm you can access it.
   This step ensures you are working under the correct Firebase project and that your account has permission to view the project resources.

3. Open **Firestore Database** and review the database named **booking**.
   This is where the UTMSport application stores and retrieves its data during runtime.

4. Confirm that the **booking** database contains the following three collections:

   * **bookings**: stores booking-related records created or retrieved by the app.
   * **event**: stores event-related records used by the app.
   * **users**: stores user-related records referenced by the app.

## **2. Flutter Project Setup**

1. Download and extract the `utmsport.zip` file from the provided link:
   [https://liveutm-my.sharepoint.com/:u:/g/personal/shahizan_live_utm_my/IQDndLdM3cTJQIWaf7HsW8p3AcDFtqr7UduSmN0fSZjMNmg?e=jjFxr9](https://liveutm-my.sharepoint.com/:u:/g/personal/shahizan_live_utm_my/IQDndLdM3cTJQIWaf7HsW8p3AcDFtqr7UduSmN0fSZjMNmg?e=jjFxr9)
   This step creates the UTMSport project folder containing all Flutter source files required to run the app.

2. Open the extracted UTMSport project folder using **VS Code**.
   This step allows you to view, edit, and run the Flutter application from the correct working directory.

## **3. Emulator Setup in VS Code**

1. In VS Code, activate the Android emulator.
   This step provides a virtual Android device environment for testing and running the mobile application.

2. Select the emulator named **Medium Phone API 36.1**.
   This ensures the application runs on the required emulator profile and Android API configuration specified for the exercise.

## **4. Running the Application**

1. In VS Code, open the main entry file:

   ```
   lib/main.dart
   ```

   This file is the application entry point and is used when launching the Flutter app.

2. Run the application using the command:

   ```
   flutter run lib/main.dart
   ```

   This command builds the Flutter application and deploys it to the active emulator (**Medium Phone API 36.1**) for execution.
