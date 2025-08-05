plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase config
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.katomaran_todoapp"
    compileSdk = 35 // You can change this to match your target (34 is safe)

    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.katomaran_todoapp"
        minSdk = 23 // Updated to meet Firebase's minimum requirement
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // Replace with release signingConfig in production
        }
    }
}

flutter {
    source = "../.."
}
