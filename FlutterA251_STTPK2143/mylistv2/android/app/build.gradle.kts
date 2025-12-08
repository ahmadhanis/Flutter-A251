import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.slumberjer.mylistv2"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.slumberjer.mylistv2"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ---------------------------------------------------------
    // LOAD key.properties (REQUIRED for release signing)
    // ---------------------------------------------------------
    val keystorePropsFile = rootProject.file("key.properties")
    val keystoreProps = Properties()

    if (!keystorePropsFile.exists()) {
        throw GradleException(
            "Missing android/key.properties! Create it to sign release builds."
        )
    } else {
        keystoreProps.load(FileInputStream(keystorePropsFile))
    }

    // ---------------------------------------------------------
    // SIGNING CONFIG FOR RELEASE
    // ---------------------------------------------------------
    signingConfigs {
        create("release") {
            storeFile = file(keystoreProps["storeFile"] as String)
            storePassword = keystoreProps["storePassword"] as String
            keyAlias = keystoreProps["keyAlias"] as String
            keyPassword = keystoreProps["keyPassword"] as String
        }
    }

    // ---------------------------------------------------------
    // BUILD TYPES
    // ---------------------------------------------------------
    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")

            // Recommended for Play Store
            isMinifyEnabled = true
            isShrinkResources = true
        }

        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
}
