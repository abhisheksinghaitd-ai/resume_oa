# 🚀 Resume Builder App (Onboarding + Profile)

A Flutter-based Resume Builder app that provides a complete onboarding flow, collects structured user data, and displays it in a clean profile format.

---

## ✨ Features

### 🔐 Authentication

* Email & Password login using Firebase Authentication
* Auto redirect:

  * New users → Onboarding
  * Existing users → Profile

---

### 🧭 Multi-Step Onboarding

Step-by-step data collection:

1. **Personal Info**

   * Name (Email auto-fetched from Firebase)

2. **Skills**

   * Add/remove skills using chip UI

3. **Experience**

   * Role, Company, Duration
   * Multiple entries supported

4. **Education**

   * Degree, Institution, Year
   * Multiple entries supported

5. **Goals**

   * Career goals (multi-line input)

---

### 👤 Profile Screen

* Clean resume-style UI
* Displays:

  * Name & Email
  * Skills (chips)
  * Experience (cards)
  * Education (cards)
  * Goals

---

### ☁️ Firebase Integration

* Firestore used for persistent storage
* Data saved once after onboarding
* Auto-loaded on login
* Users don’t need to re-enter details

---

### 🧠 State Management

* Provider used for managing onboarding state
* Smooth data flow across screens

---

## 🛠 Tech Stack

* **Flutter (Dart)**
* **Firebase Authentication**
* **Cloud Firestore**
* **Provider (State Management)**

---

## 📂 Project Structure

```
lib/
 ┣ model/
 ┃ ┗ user_profile.dart
 ┣ providers/
 ┃ ┗ user_provider.dart
 ┣ screens/
 ┃ ┣ auth/
 ┃ ┣ onboarding/
 ┃ ┣ profile/
 ┣ services/
 ┃ ┗ auth_service.dart
```

---

## 📱 App Flow

```
Login/Register
      ↓
Check Firestore
      ↓
If New User → Onboarding (5 Steps)
If Existing → Profile Screen
```

---

## ⚙️ Setup Instructions

1. Clone the repository

```bash
git clone https://github.com/abhisheksinghaitd-ai/resume_oa.git
cd resume_oa
```

2. Install dependencies

```bash
flutter pub get
```

3. Add Firebase configuration

* Place `google-services.json` in:

```
android/app/
```

4. Enable in Firebase Console:

* Authentication → Email/Password
* Firestore Database

5. Run the app

```bash
flutter run
```

---

## 🔒 Firestore Rules (for development)

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## 📌 Future Improvements

* ✏️ Edit Profile functionality
* 📸 Profile image upload
* 🌐 Cloud sync across devices
* 🎨 Advanced UI animations
* 📄 Resume export (PDF)

---

## 👨‍💻 Author

**Abhishek Singh**

* B.Tech IT @ AITH Kanpur
* Flutter Developer

---

## ⭐ Notes

This project was built as part of a coding assessment focusing on:

* UI/UX design
* Structured data handling
* Firebase integration
* Clean architecture


*Add screenshots here for better presentation*
