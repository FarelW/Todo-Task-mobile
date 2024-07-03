# Todo Task Mobile

A simple Todo List mobile application built with Flutter.

## Features

- Add, view, update, and delete tasks
- Filter tasks by completion status
- Sort tasks by due date
- Responsive design

## Prerequisites

- Flutter SDK
- Dart SDK

## Installation

Follow these steps to set up and run the project locally.

### 1. Clone the repository

```sh
git clone https://github.com/FarelW/Todo-Task-mobile.git
cd Todo-Task-mobile
```

### 2. Install dependencies

```sh
flutter pub get
```

### 3. Run the app

```sh
flutter run
```

## Build APK

### 1. Build the release APK:

```sh
flutter build apk --release
```

### 2. Locate the APK:

```sh
location: build/app/outputs/flutter-apk/app-release.apk
```

## API
This app interacts with the Todo Task API hosted at https://todo-task-submission.vercel.app.

## Endpoints
- Get Tasks: /api/trpc/task.getTask
- Add Task: /api/trpc/task.addTask
- Delete Task: /api/trpc/task.deleteTask
- Mark Task as Done: /api/trpc/task.markDone
- Mark Task as Undone: /api/trpc/task.markUndone

## Tech Stack

- Flutter: UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase
- Dart: Client-optimized programming language for apps on multiple platforms

## Learn More

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Links
- Repository : https://github.com/FarelW/Todo-Task-mobile
- Issue tracker :
   - If you encounter any issues with the program, come across any disruptive bugs, or have any suggestions for improvement, please don't hesitate to tell the author
- Github main contributor :
   - (Farel Winalda) - https://github.com/FarelW
- Also, this is the apk link download : https://drive.google.com/drive/folders/172sWgYBk4g0tsHI4bca6Gan6efq6FcYE?usp=sharing