# 🎥 Twitch Clone Pro App  

A **Twitch-like live streaming application** built with **Flutter**, powered by **Supabase** for authentication, realtime database, storage, and cloud functionality. This app supports **two user roles**:  
- **Broadcasters** → can start livestreams and interact with viewers.  
- **Viewers** → can join livestreams, watch in real-time, and comment.  

The project implements **persistent authentication** with `provider` for state management, ensuring seamless user sessions without repeated logins.  

## 📸 Screenshots  

| Screen 1 | Screen 2 | Screen 3 | Screen 4 |
|----------|----------|----------|----------|
| <img src="https://github.com/user-attachments/assets/97a1d184-758a-4be6-8407-2a4dc96020b7" width="200"/> | <img src="https://github.com/user-attachments/assets/85bc143a-767d-4e72-9720-89c1f09431d2" width="200"/> |  <img src="https://github.com/user-attachments/assets/e38a223e-1182-49a8-91f8-a59b364d3a1b" width="200"/> |<img src="https://github.com/user-attachments/assets/8d1e5f72-a7f3-4c27-bd94-35b3f92f2cf2" width="200"/> |



## ✨ Features  

- ✅ **User Authentication**  
  - Signup and Login using **Supabase Auth**  
  - Persistent login state (no need to re-login every time)  

- ✅ **Roles**  
  - **Broadcaster**: Start livestreams, stream video in real-time, see active viewers count.  
  - **Viewer**: Join livestreams, watch and interact, post comments in real-time.  

- ✅ **Live Streaming**  
  - Broadcasters can go live instantly.  
  - Viewers see updated **active viewer counts**.  
  - Comments/chat in real-time during the livestream.  

- ✅ **Supabase Integration**  
  - **Realtime Database** → Tracks livestreams, comments, viewer counts, broadcaster state.  
  - **Supabase Storage** → Handles thumbnails, profile pictures, and other assets.  
  - **Cloud Application** → All data synced across devices instantly.  

- ✅ **State Management**  
  - Built with **Provider** for efficient state management.  
  - **Persistent state** ensures users stay logged in across app restarts.  

---

## 🏗️ Tech Stack  

- **Frontend**: Flutter (Dart)  
- **Backend / Cloud**: Supabase (Auth, Realtime DB, Storage)  
- **State Management**: Provider  
- **Video Streaming**: Agora / WebRTC integration (for livestreams)  

---

## 📂 Project Structure  
```
lib/
│── main.dart # Entry point
│── providers/ # State management (Provider)
│── screens/ # UI Screens (Login, Signup, Live, Home)
│── services/ # Supabase & API services
│── widgets/ # Reusable components
│── models/ # Data models (User, Livestream, Comment)
```

Backend Agora Server: 
```
https://github.com/Hafiz-Umar-Ahmed/agora-server
```
