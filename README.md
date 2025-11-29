# Rukunin - Community Management Made Simple

![Project banner](docs/img/banner.png)

Rukunin is a powerful yet easy-to-use mobile app designed for Indonesia’s RT/RW system. It helps residents and local leaders streamline neighborhood administration, communication, and daily activities—all in one place.

Whether you’re a Ketua RT/RW, a community officer, or a resident, Rukunin makes it easier to manage:

- 🧾 Administrative documents

- 💰 Community finances and payments

- 📅 Events, meetings, and announcements

- 🏘️ Daily neighborhood tasks and coordination

Built with a complete mobile-first experience, Rukunin empowers every household to stay informed, collaborate, and take action without paperwork or complicated systems.

**🚀 Try the App Demo**

Want to see how it works? Check out the live preview and experience Rukunin in action:
[Visit my app demo](#app-demo)


---
---

## System Architecture

![architectural-diagram](docs/img/architectural-diagram.jpg)

Rukunin is built with a cloud-based architecture to ensure fast development and reliable performance.

- **Flutter (Frontend)**

    The mobile app is developed using Flutter for cross-platform support on Android, iOS, and website.

- **Firebase (Backend Services)**

    Provides core backend functionality such as authentication, database, storage, notifications, and serverless functions.

- **Google Cloud Platform + Vertex AI (ML Services)**

    Used to deploy a custom machine learning model for identifying fake receipt images in real time.

All components communicate seamlessly through the Firebase SDK, enabling a scalable and maintainable system with minimal infrastructure overhead.

## App Demo

This app is designed to work seamlessly across platforms, especially on native Android and the web, by leveraging the full capabilities of the Flutter framework.  
You can access our web app for a quick and easy demonstration:

👉🏻 https://rukunin-app.web.app/

Below are demo user accounts you can use to sign in:

| No. | Role | Email | Password |
| --- | --- | --- | --- |
| 1. | Admin | admin@rukunin.app | admin123 |
| 2. | Ketua RW | ketuarw@rukunin.app | ketuarw123 |
| 3. | Ketua RT | ketuart@rukunin.app | ketuart123 |
| 4. | Secretary | sekretaris@rukunin.app | sekretaris123 |
| 5. | Treasurer | bendahara@rukunin.app | bendahara123 |
| 6. | Warga | warga@rukunin.app | warga123 |