# 🚦 TrafficGuardian – Flutter Frontend

This is the **Flutter-based mobile frontend** for the final year project **"Motorbike Safety Violations System for Police"**. It works alongside the Python backend API to help traffic wardens receive real-time alerts, issue challans, and manage traffic violation data directly from their smartphones.

---

## 📱 Features

- 🔐 Warden login and authentication
- 🚓 Real-time motorbike violation alerts
- 🖼️ View bike image, number plate, and violation type
- 🗂️ View and manage assigned chowkis and directions
- 📋 View challan history
- 📡 Communication with AI-enabled Python backend (YOLOv8 + OCR)

---

## 🛠️ Tech Stack

- **Frontend:** Flutter
- **Backend API:** Python Flask
- **AI Models:** YOLOv8 (helmet detection, number plate), Tesseract (OCR)
- **Database:** MySQL (via SQLAlchemy)

---

## 📦 Project Structure

```
lib/
├── AdminScreens/              # Data models for API communication
├── LoginScreens/             # UI screens (Login, Dashboard, Alerts, etc.)
├── MobileCamera/            # API service classes
├── Model/             # Custom reusable widgets
└── Services/     # Api Calling  
└── main.dart # App entry point
```

---

## 🚀 Getting Started

### 📋 Prerequisites

- Flutter SDK installed
- VS Code or Android Studio
- Git
- Backend API running locally or on a server

### 🧪 Setup Instructions

```bash
git clone https://github.com/MohsinALi1a1/MotorbikeSafety.git
cd MotorbikeSafety
flutter pub get
flutter run
```

⚠️ Make sure to update the API base URL in your code (usually in a `ApiHandle.dart`) to point to your running Python backend.

---

## 🔗 Backend API Example

| Functionality       | Method | Endpoint                |
|---------------------|--------|-------------------------|
| Login               | POST   | `/login`                |
| Fetch Chowkis       | GET    | `/get_chowkis`          |
| Receive Alerts      | GET    | `/get_alerts`           |
| Submit Challan      | POST   | `/issue_challan`        |
| Upload Image        | POST   | `/upload`               |

---

## 📲 Building APK

```bash
flutter build apk --release
```

APK will be available in:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 👥 Team

This project was developed as part of the BSCS Final Year Project at PMAS Arid Agriculture University (BIIT).

- 👨‍💻 Mohsin Ali  
- 🎓 Final Year BSCS (AI Specialization) – 8th Semester  
- 📆 Graduation: June 2025

---

## 🛡️ License

This repository is for academic and learning purposes only.

---

## 🌐 Related Projects

- [TrafficGuardian Backend (Python)](https://github.com/MohsinALi1a1/TrafficGuardian)
