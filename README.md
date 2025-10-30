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

## 🧭 App Architecture & Flow

The mobile application follows a clean, user-friendly flow that connects all the system’s core functionalities — from authentication to real-time alerts and video playback.  

The app architecture is designed using the **MVVM (Model–View–ViewModel)** pattern to separate the business logic from the UI, ensuring scalability and maintainability.

---

### 🔄 App Flow Overview

1. **App Launch (Splash Screen):**  
   When the user opens the app, a splash screen with the project logo appears while the app initializes required services.

2. **Authentication:**  
   Users can either sign up for a new account or log in using their credentials.  
   The app communicates with the ASP.NET backend for secure authentication via JWT tokens.

3. **PIN Verification:**  
   For enhanced security, users verify their login using a 4-digit PIN before accessing the main dashboard.

4. **Main Dashboard:**  
   After login, users are redirected to the home screen, where they can:
   - View connected cameras  
   - Check the camera’s current status (online/offline)  
   - Access real-time video streams

5. **Add Camera:**  
   From the add camera screen, users can manually input their camera credentials (IP, port, username, password) to connect new streams to the system.

6. **Notifications:**  
   Whenever the AI backend detects a violent or suspicious activity, a **real-time push notification** is sent to the app through **Firebase Cloud Messaging (FCM)**.  
   Users can open these alerts to view detailed incident information.

7. **Recorded Videos:**  
   Detected events are saved in MinIO storage and retrieved through the backend.  
   The user can view these recorded clips directly from the app’s “Records” tab.

8. **Settings:**  
   Users can manage account information, switch between dark and light modes, and contact support.

---

### 🧩 Architecture Summary

| Layer | Description |
|--------|-------------|
| **Presentation Layer** | Built with Flutter UI components following clean design patterns |
| **Logic Layer** | Uses Provider for state management and data flow between UI and API |
| **Data Layer** | Handles communication with the backend API and Firestore (for notifications) |
| **Integration** | Connected with ASP.NET backend, MinIO, SRS streaming, and FCM for notifications |

---

### 🗺️ Visual Flow

The diagram below represents the end-to-end flow of the mobile app:

![App Flow](./app-flow.png)

> The flow starts when the user opens the app and continues through login, camera management, notification alerts, and video playback — reflecting the real-time interaction between the mobile app, backend API, and AI services.



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
