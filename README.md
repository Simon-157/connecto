

<!-- ```markdown -->
# Connecto App

## Overview
Connecto is a mobile application designed to bridge the gap between Ghanaian students seeking valuable learning experiences and professionals eager to share their expertise. The app provides mentorship, internships, and connections to potential employers in the Ghanaian market.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Development](#development)
- [Branching Strategy](#branching-strategy)
- [Contributing](#contributing)
- [License](#license)

## Features
- User Authentication and Profile Customization
- Candidates and Professionals Connection Management
- In-app Chat Communication
- Media Integration for Images and Videos
- Update Notifications
- Calendar Integration for Scheduled Mentorships or Interviews
- Geolocation-based Matching
- Audio Calls for Virtual Recruitment Sessions
- Feedback and Rating System
- Mentorship and Job Feeds

## Project Structure
```
connecto_app/
├── android/
├── ios/
├
└── 📁lib
    └── 📁controllers
        └── location_controller.dart
    └── main.dart
    └── 📁models
        └── connection_model.dart
        └── event_model.dart
        └── job_feed_model.dart
        └── media_model.dart
        └── message_model.dart
        └── notification_model.dart
        └── user_model.dart
    └── 📁screens
        └── 📁auth
            └── login_screen.dart
            └── register_screen.dart
        └── 📁explore
            └── location_explore.dart
        └── 📁jobs
            └── job_detail_screen.dart
            └── jobs_feed.dart
        └── 📁onboarding
            └── onboarding_screen.dart
            └── splash_screen.dart
    └── 📁services
        └── auth_service.dart
        └── location_service.dart
    └── 📁shared
        └── bottom_snake_bar.dart
        └── bottom_wrapper.dart
        └── page_navigation.dart
    └── 📁utils
        └── constants.dart
        └── data.dart
    └── 📁widgets
        └── 📁explore
            └── feeds_found_modal.dart
            └── map_widget.dart
        └── 📁jobs
            └── jobcard.dart
            └── jobtag.dart
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
├── pubspec.yaml
└── README.md
```

## Getting Started
### Prerequisites
- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK: Comes with Flutter installation
- Android Studio or Xcode for iOS development

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Simon-157/connecto.git
   cd connecto_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Development
### Running Tests
To run unit and widget tests:
```bash
flutter test
```

For integration tests:
```bash
flutter drive --target=test_driver/app.dart
```

## Branching Strategy
### Branch Rule
The `main` branch is protected and does not allow direct pushes. All changes must be made through pull requests (PRs) and approved by at least one reviewer.

### Workflow
1. **Create a Feature Branch**: Branch off from `main`.
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**: Commit your changes with clear and concise messages.
   ```bash
   git add .
   git commit -m "Add feature X"
   ```

3. **Push to Your Branch**:
   ```bash
   git push origin feature/your-feature-name
   ```

4. **Create a Pull Request**: Go to the repository on GitHub and create a PR against the `main` branch. Provide a detailed description of your changes.

5. **Code Review**: Ensure your PR is reviewed and approved by at least one team member.

6. **Merge**: Once approved, your PR will be merged into the `main` branch by a maintainer.

## Contributing
We welcome contributions from the community. To contribute, follow these steps:

1. Fork the repository.
2. Clone your forked repository:
   ```bash
   git clone https://github.com/Simon-157/connecto.git
   cd connecto_app
   ```
3. Create a new branch for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. Make your changes and commit them:
   ```bash
   git commit -m "Description of the changes"
   ```
5. Push your changes to your forked repository:
   ```bash
   git push origin feature/your-feature-name
   ```
6. Create a pull request from your branch to the `main` branch of the original repository.

### Code of Conduct
Please adhere to our [Code of Conduct](CODE_OF_CONDUCT.md) when contributing to this project.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
```
