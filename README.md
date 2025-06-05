# 💰 Debt Manager App

A futuristic and intelligent Flutter app to help users manage their debts effortlessly. Powered by Firebase for secure authentication and real-time data handling, Gemini AI for financial tips, and Cloudinary for smooth image handling. Export your data as CSV and stay in control with a beautiful and modern UI.

---

## 🚀 Features

- 🔐 **Firebase Authentication** – Secure user login & registration (Email/Password & Google Sign-In).
- ☁️ **Firebase Firestore** – Real-time debt tracking and storage.
- 🧠 **Gemini AI Integration** – Smart financial suggestions and debt reduction tips.
- 🖼️ **Cloudinary Uploads** – Upload and store user profile pictures in the cloud.
- 📊 **CSV Exporter** – Export your debt history as a CSV file.
- 🌙 **Dark/Light Theme Switch** – Toggle UI modes for comfort and style.
- 📱 **Futuristic UI** – Sleek animations and modern design for an intuitive experience.

---


## 🛠️ Tech Stack

- **Flutter**
- **Firebase (Auth, Firestore)**
- **Cloudinary API**
- **Google Gemini AI**
- **CSV Export (dart:io, csv package)**
- **fl_chart for charts & stats**
- **Firebase UI Auth for seamless login**

---

## 🔧 Setup Instructions

1. **Clone the repository:**

   ```bash
   git clone https://github.com/your-username/debt_manager.git
   cd debt_manager
2. **Install dependencies:**

   ```bash
   flutter pub get
3. **Firebase Setup:**
   - Create a Firebase project at Firebase Console

  - Enable Authentication (Email/Password & Google)

  - Create Firestore Database

  - Add google-services.json (Android) and GoogleService-Info.plist (iOS)
    
4. **Cloudinary Setup:**
  - Sign up at Cloudinary

  - Get your cloud name, API key, and API secret

  - Configure in your app’s .env or constants
    
5. **Gemini API Setup:**
  - Get API key from Google AI Studio

  - Add your Gemini key in your app’s config file
    
6. **Run the App::**
```bash
   flutter run
  
