import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.norkacare_app"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    // Load signing properties from the android/key.properties file if present
    // Import java.util.Properties at top of this block to avoid unresolved reference
    val keyPropertiesFile = rootProject.file("key.properties")
    val keyProperties = Properties()
    if (keyPropertiesFile.exists()) {
        keyProperties.load(keyPropertiesFile.inputStream())
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.norkacare_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = 4
        versionName = "1.0.3"
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // Use release signing config when key.properties is provided.
            // The properties file should contain: storePassword, keyPassword, keyAlias, storeFile
            signingConfigs {
                create("release") {
                    // Fallbacks in case properties are missing will keep previous behavior
                    val storeFilePath = keyProperties.getProperty("storeFile")
                    if (storeFilePath != null) {
                        // Resolve the keystore path relative to the project root so a keystore
                        // placed at the repository root (e.g. ../norkacare.keystore) or project root
                        // is found reliably.
                        storeFile = rootProject.file(storeFilePath)
                    }
                    storePassword = keyProperties.getProperty("storePassword") ?: ""
                    keyAlias = keyProperties.getProperty("keyAlias") ?: ""
                    keyPassword = keyProperties.getProperty("keyPassword") ?: ""
                }
            }

            signingConfig = signingConfigs.getByName("release")
            
            // To enable code shrinking and optimization, uncomment the following lines:
            // isMinifyEnabled = true
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
