# Katomaran Hackathon – To-Do App

## Setup Instructions

1. Clone the repository:

git clone https://github.com/shreeshainiha-js/katomaran-hackathon.git
cd katomaran-hackathon
flutter pub get

2. Add Firebase config:

Place google-services.json inside android/app/

3. Run the app:

flutter run

4. Build APK (optional):

flutter build apk --release

## APK Download

https://drive.google.com/file/d/1EudaXt7R431_14npPrpRIDl0wSFQZDp0/view?usp=drive_link

## Model Diagram

![Model Diagram](model%20todo.png)

## Explanation

https://www.loom.com/share/76dc1ea35c714c85b70ee24f79bcfbb6?sid=f99c7b77-ee1c-4111-972f-72a014bbb270

## Assumptions

- Only Google Sign-In is used.
- Tasks are stored in local state (not in Firestore or database).

This project is a part of a hackathon run by https://www.katomaran.com
