# LeetCode Stats App 📊

> [!IMPORTANT]
> **Status: Early Development** > This project is currently in the very early stages of development. Features are being planned, and the core architecture is being built.

---

A cross-platform application designed to provide a **beautiful, intuitive dashboard** for tracking and visualizing your LeetCode progress. Whether you're preparing for technical interviews or competitive programming, this app helps you stay on top of your game across all your devices.

---

## 🚀 Vision
The goal of this project is to move beyond simple statistics and provide a comprehensive visual representation of your coding journey.

### Key Features (In Progress)
* **Beautiful Dashboard:** A modern, clean UI focusing on data visualization, including progress charts, category breakdowns, and consistency streaks.

* **True Cross-Platform:** Built to run seamlessly on:
    * 📱 **Android**
    * 🍏 **iOS**
    * 🌐 **Web**


---

## 🛠️ Tech Stack (Planned)
* **Frontend:** Flutter (Multi-platform UI)
* **State Management:** Provider / BLoC
* **Backend:** FastAPI, GraphQL

---

## 📂 Backend Structure
The backend is organized for modularity and scalability:

```text
backend/
├── app/
│   ├── main.py             # Entry point
│   ├── core/               # Configuration & Constants
│   ├── api/                # API Routing (Profile, Badge, Stats, Calendar)
│   ├── services/           # Business logic & GraphQL client
│   ├── models/             # Data schemas
│   └── utils/              # Streak calculation & Heatmap parsing
├── requirements.txt        # Dependencies
└── .env                    # Environment variables