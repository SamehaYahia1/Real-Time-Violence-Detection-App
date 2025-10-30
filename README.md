# 📱 Real-Time Violence Detection – Mobile App

## 🔍 Overview
This mobile application serves as the **frontend interface** of the Real-Time Violence Detection System.  
It allows users to:
-  Log in securely using their credentials.
-  Add and manage connected cameras.
-  Receive **real-time alerts** when the AI model detects suspicious or violent actions.
-  View saved video clips and notification history.

The app communicates with the **ASP.NET Core backend API** and integrates **Firebase Cloud Messaging (FCM)** for push notifications.

---

## 🧩 Project Repositories
This system is composed of three main repositories working together:

| Component | Repository | Description |
|------------|-------------|-------------|
|  **Backend API** | [Real-Time-Violence-Detection-Backend](https://github.com/SamehaYahia1/Real-Time-Violence-Detection) | Handles authentication, camera management, subscriptions, and coordination with AI services |
|  **AI Microservices** | [Violence-Detection-AI-Services](https://github.com/SamehaYahia1/Violence-Detection-AI-Services) | Python-based AI services for real-time video analysis and detection |
|  **Mobile App (this repo)** | [Real-Time-Violence-Detection-App](https://github.com/SamehaYahia1/Real-Time-Violence-Detection-App) | Flutter frontend for users to interact with the system and receive alerts |

---

## 🛠️ Tech Stack

| Feature | Technology |
|----------|-------------|
| Framework | Flutter |
| Backend Communication | REST API (ASP.NET Core) |
| Authentication | JWT |
| Notifications | Firebase Cloud Messaging (FCM) |
| State Management | Provider |
| Local Storage | SharedPreferences |
| Cloud Storage | Firestore |
| Video Playback | `flutter_vlc_player` |
| API Integration | HTTP / Dio |

---

## 🚀 Setup & Run

### Prerequisites
Before running the app, ensure you have:
-  Flutter SDK installed  
-  Android Studio or Visual Studio Code  
-  A configured Firebase project (for notifications)  
-  The backend API running locally or hosted  

### Steps

```bash
# 1️⃣ Clone this repository
git clone https://github.com/SamehaYahia1/Real-Time-Violence-Detection-App.git

# 2️⃣ Navigate to the project directory
cd Real-Time-Violence-Detection-App

# 3️⃣ Install dependencies
flutter pub get

# 4️⃣ Run the app
flutter run
