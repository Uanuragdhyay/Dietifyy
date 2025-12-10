## **📜 README.md - Dietary Plan Tracker App**

# 🥗 **Dietary Plan Tracker**
A **Flutter-based app** that allows users to **sign up, log in**, and **manage dietary plans**. It features **Google & Email Authentication**, **Firestore Database Integration**, and **a to-do style dietary plan tracker**.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)  
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)  
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)

---

## **✨ Features**

✅ **Authentication System** (Google & Email/Password Login)  
✅ **Firestore Database Integration** (User Data Storage)  
✅ **Complete Profile Setup** (Gender, DOB, Preferences, Allergies)  
✅ **Dietary Plan Tracker** (Add, Edit, Delete, Mark as Completed)  
✅ **Beautiful UI** with Custom Buttons & Cards  
✅ **Works on Android & iOS**

---

## **🛠 Tech Stack**
| Tech | Description |
|------|------------|
| **Flutter** 🖥️ | UI Framework |
| **Dart** 🦄 | Programming Language |
| **Firebase Auth** 🔐 | Authentication System |
| **Firestore** 🔥 | Cloud Database |
| **Google Sign-In** 🌍 | OAuth Login |
| **Provider / GetX** 🌐 | State Management |
| **Shared Preferences** 💾 | Persistent Storage |

---

## **📂 Folder Structure**
```
📦 myproject
 ┣ 📂 lib
 ┃ ┣ 📂 core
 ┃ ┃ ┣ 📂 common
 ┃ ┃ ┃ ┣ 📂 widgets
 ┃ ┃ ┃ ┃ ┣ custom_button.dart
 ┃ ┃ ┃ ┃ ┣ custom_text_field.dart
 ┃ ┃ ┣ 📂 config
 ┃ ┃ ┃ ┣ theme.dart
 ┃ ┃ ┣ 📂 routes
 ┃ ┃ ┃ ┣ app_routes.dart
 ┃ ┣ 📂 features
 ┃ ┃ ┣ 📂 auth
 ┃ ┃ ┃ ┣ 📂 views
 ┃ ┃ ┃ ┃ ┣ sign_in_screen.dart
 ┃ ┃ ┃ ┃ ┣ sign_up_screen.dart
 ┃ ┃ ┃ ┃ ┣ forgot_password_screen.dart
 ┃ ┃ ┣ 📂 home
 ┃ ┃ ┃ ┣ home_screen.dart
 ┃ ┃ ┣ 📂 profile
 ┃ ┃ ┃ ┣ profile_screen.dart
 ┃ ┃ ┣ 📂 dietary
 ┃ ┃ ┃ ┣ dietary_plan_screen.dart
 ┃ ┣ main.dart
```

---

## **🚀 How to Run the Project**

### **📌 Prerequisites**
1️⃣ **Install Flutter SDK** → [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)  
2️⃣ **Set up Firebase** for authentication & Firestore database  
3️⃣ **Enable Google Sign-In** in Firebase Console

### **📦 Setup Project**
```bash
git clone https://github.com/Uanuragdhyay/Dietifyy
cd dietary-tracker
flutter pub get
```

### **🔥 Run the App**
```bash
flutter run
```

### **🛠 Build for Production**
```bash
flutter build apk   # Android
flutter build ios   # iOS
```

---

## **🔧 Firebase Setup Instructions**

1️⃣ Go to [Firebase Console](https://console.firebase.google.com/)  
2️⃣ Create a Firebase Project  
3️⃣ Enable **Authentication** (Google, Email/Password)  
4️⃣ Set up **Cloud Firestore**  
5️⃣ Download **google-services.json** (Android) and **GoogleService-Info.plist** (iOS)  
6️⃣ Place them inside `android/app/` & `ios/Runner/` respectively

---

## **📷 Screenshots**

| **Login Page** | **Dietary Tracker** | **Profile Page** |
|---------------|---------------------|------------------|
| ![Login](https://via.placeholder.com/150) | ![Tracker](https://via.placeholder.com/150) | ![Profile](https://via.placeholder.com/150) |

---

## **💡 Future Enhancements**
✅ **Push Notifications** for meal reminders  
✅ **AI-based diet suggestions**  
✅ **Dark Mode UI**  
✅ **Sync with Google Fit & Apple Health**

---

## **🤝 Contributing**
Got a feature request? Feel free to **fork, open an issue, or create a PR**! 🎉


---

## **💌 Contact & Support**
📧 Email: [uanurag@gmail.com](mailto:uanurag@gmail.com)  
📌 GitHub: [GitHub Profile](https://github.com/Uanuragdhyay)

---
