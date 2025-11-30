# Flutter Todo App

A minimalist, beautiful, and Bloc-powered Flutter application for managing tasks with persistent storage.

## Features

- **State Management**: Uses `flutter_bloc` for predictable state management.
- **Data Models**: robust models using `freezed` and `json_serializable`.
- **Persistence**: Saves tasks locally using `shared_preferences`.
- **Filtering**: Filter tasks by All, Completed, Pending or Deleted.
- **UI**: Modern Material 3 design.

## Setup & Run

1.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

2.  **Generate Code**
    This project uses code generation for models. Run the following command:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

3.  **Run the App**
    ```bash
    flutter run
    ```

## Project Structure

- `lib/bloc`: Contains Business Logic Components (Blocs).
- `lib/models`: Data models (Freezed).
- `lib/services`: Data storage services.
- `lib/ui`: UI components (Screens and Widgets).
- `lib/theme`: App theming.

