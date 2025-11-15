
<a href="https://github.com/drshahizan/mobile_apps/stargazers"><img src="https://img.shields.io/github/stars/drshahizan/mobile_apps" alt="Stars Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/network/members"><img src="https://img.shields.io/github/forks/drshahizan/mobile_apps" alt="Forks Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/pulls"><img src="https://img.shields.io/github/issues-pr/drshahizan/mobile_apps" alt="Pull Requests Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/issues"><img src="https://img.shields.io/github/issues/drshahizan/mobile_apps" alt="Issues Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/graphs/contributors"><img alt="GitHub contributors" src="https://img.shields.io/github/contributors/drshahizan/mobile_apps?color=2b9348"></a>
![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan%2Fmobile_apps&labelColor=%23d9e3f0&countColor=%23697689&style=flat)

# 🧪 Exercise 2: Connect Flutter App to Firebase + Firestore

### 🎯 Objektif

Pada akhir latihan ini, anda akan boleh:

1. Cipta projek Flutter
2. Sambungkan Flutter ke Firebase menggunakan fail `google-services.json`
3. Inisialisasi Firebase dalam Flutter
4. Baca & tambah data ke Firestore (collection `notes` yang telah anda buat)


# 📌 LANGKAH 1 — Buat Projek Flutter Baharu

1. Buka **Terminal** di Mac
   (Spotlight → “Terminal”)

2. Taip:

```bash
flutter create nota_app
cd nota_app
```

3. Jalankan projek untuk memastikan ia berfungsi:

```bash
flutter run
```

Jika app demo (counter app) muncul → ✔ berjaya.


# 📌 LANGKAH 2 — Daftarkan App Android dalam Firebase Console

> Kita mula dengan versi Android dahulu sebab langkahnya paling mudah.

1. Pergi ke **Firebase Console**
   🔗 [https://console.firebase.google.com](https://console.firebase.google.com)

2. Pilih projek anda (contoh: *NotaFlutterApp*)

3. Pada dashboard, pergi ke seksyen **Build → Firestore Database**
   (Pastikan Firestore sudah aktif dari Exercise sebelum ini)

4. Di bahagian tengah atas, klik ikon **Android** (Add app).


## 📌 LANGKAH 2.1 – Masukkan Maklumat App Android

Firebase minta 3 perkara:

### **1. Android package name**

Anda ambil dari Flutter:

Buka fail:

```
android/app/src/main/AndroidManifest.xml
```

Cari baris:

```xml
package="com.example.nota_app"
```

**Salin value itu** → masukkan ke Firebase.

### **2. App nickname**

Pilihan sahaja.
Contoh:
`NotaApp Android`

### **3. SHA-1**

Untuk latihan asas → **skip dahulu** (Firebase tak wajib untuk Firestore)

Klik **Register app**.


# 📌 LANGKAH 3 — Muat Turun & Letakkan `google-services.json`

1. Firebase akan suruh anda download fail:
   **`google-services.json`**

2. Letak fail itu ke dalam folder:

```
android/app/
```

✔ **Fail ini sangat penting**
Tanpa fail ini, Flutter tak boleh connect ke Firebase.


# 📌 LANGKAH 4 — Aktifkan Plugin Google Services dalam Android

Buka fail berikut dan tambah kod seperti di bawah:


### 📂 Fail 1: `android/build.gradle`

Cari bahagian:

```gradle
buildscript {
    dependencies {
        // Tambah baris ini
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```


### 📂 Fail 2: `android/app/build.gradle`

Tambahkan di bahagian paling bawah:

```gradle
apply plugin: 'com.google.gms.google-services'
```

Simpan semua fail.


# 📌 LANGKAH 5 — Pasang Pakej Firebase dalam Flutter

Buka `pubspec.yaml`, cari bahagian `dependencies:` dan tambah:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.0.0
  cloud_firestore: ^5.0.0
```

Kemudian:

```bash
flutter pub get
```


# 📌 LANGKAH 6 — Inisialisasi Firebase dalam Flutter

Buka `lib/main.dart`.

Tukar daripada kod asal kepada:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotaPage(),
    );
  }
}
```


# 📌 LANGKAH 7 — Buat UI Mudah untuk Tambah & Papar Nota

Tambah kod ini di bawah MyApp:

```dart
class NotaPage extends StatefulWidget {
  @override
  State<NotaPage> createState() => _NotaPageState();
}

class _NotaPageState extends State<NotaPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> tambahNota() async {
    final teks = _controller.text.trim();
    if (teks.isEmpty) return;

    await FirebaseFirestore.instance.collection('notes').add({
      'text': teks,
      'createdAt': DateTime.now(),
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notes App")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write your note…",
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: tambahNota,
                  child: const Text("Add"),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notes')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),

              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(child: Text("No notes yet."));
                }

                return ListView(
                  children: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['text'] ?? ''),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```


# 📌 LANGKAH 8 — Jalankan App

Dalam terminal:

```bash
flutter run
```

Jika berjaya:

✔ Anda boleh taip nota
✔ Tekan "Add"
✔ Nota masuk ke Firestore
✔ Real-time list terus muncul dalam UI


# 🎉 LATIHAN TAMAT

Anda sekarang sudah berjaya:

* Buat app Flutter
* Sambung ke Firebase
* Simpan & baca data dari Firestore



## Contribution 🛠️
Please create an [Issue](https://github.com/drshahizan/mobile_apps/issues) for any improvements, suggestions or errors in the content.

You can also contact me using [Linkedin](https://www.linkedin.com/in/drshahizan/) for any other queries or feedback.

[![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan&labelColor=%23697689&countColor=%23555555&style=plastic)](https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fdrshahizan)
![](https://hit.yhype.me/github/profile?user_id=81284918)


