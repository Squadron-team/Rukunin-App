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

## Our Team

We are **Squadron Team**, a group of four developers collaborating to build Rukunin with a shared mission of supporting digital transformation in local communities.

| No. | Name | GitHub | Role | 
| --- | --- | --- | --- |
| 1. | Farrel Augusta Dinata | https://github.com/FarrelAD | Project lead, Fullstack developer |
| 2. | Khoirotun Nisa' | https://github.com/KhoirotunNisa25 | Frontend developer |
| 3. | Muhammad Nasih | https://github.com/muhnasih | Frontend developer |
| 4. | Naditya Prastia Andino | https://github.com/Naditya206 | Frontend developer |

## Acknowledgement

This project was developed with assistance from AI tools. We used **ChatGPT 5** for brainstorming ideas, technical planning, and architectural discussions. We used **Claude Sonnet 4.5** for code suggestions and improvements, particularly on the frontend side. All final design choices, implementation, testing, and verification were conducted by the **Squadron Team**.

## Future Direction

Rukunin will continue to evolve with new features, performance improvements, and better user experience. Our goal is to keep expanding the platform to support digital community management and empower RT/RW environments in Indonesia.

We welcome feedback, suggestions, and contributions. Feel free to open an issue or submit a pull request!