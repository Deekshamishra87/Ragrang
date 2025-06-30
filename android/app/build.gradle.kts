plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.rag_rang_app"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.example.rag_rang_app"
        minSdk = 23
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
    signingConfigs {
        create("myDebug") {
            storeFile = file("${rootDir}/debug.keystore")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("myDebug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }


    flutter {
        source = "../.."
    }

    dependencies {
        // ✅ Firebase BoM
        implementation(platform("com.google.firebase:firebase-bom:33.13.0"))

        // ✅ Add Firebase services you need
        implementation("com.google.firebase:firebase-analytics")
        // implementation("com.google.firebase:firebase-auth")
        // implementation("com.google.firebase:firebase-firestore")
    }
}
