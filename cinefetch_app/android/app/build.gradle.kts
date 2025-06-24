//import java.io.FileInputStream
//import java.util.Properties

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

//val keystorePropertiesFile = rootProject.file("key.properties")
//val keystoreProperties = Properties().apply {
    //if (keystorePropertiesFile.exists()) {
        //load(FileInputStream(keystorePropertiesFile))
    //}
//}

android {
    namespace = "com.example.cinefetch_app"
    compileSdk = 35 
    ndkVersion = "27.0.12077973"

    //signingConfigs {
    //create("release") {
        //storeFile = file("../upload-keystore.jks")
        //storePassword = keystoreProperties.getProperty("storePassword")
        //keyAlias = keystoreProperties.getProperty("keyAlias")
        //keyPassword = keystoreProperties.getProperty("keyPassword")
    //}
//}

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.cinefetch_app"
        minSdk = 23
        targetSdk = 35
        versionCode = (flutter.versionCode?.toInt() ?: 1)
        versionName = flutter.versionName ?: "1.0"
    }

    buildTypes {
        //getByName("release") {
            //signingConfig = signingConfigs.getByName("release")
            //isMinifyEnabled = true
            //isShrinkResources = true
            //proguardFiles(
                //getDefaultProguardFile("proguard-android-optimize.txt"),
                //"proguard-rules.pro"
            //)
        //}
        release{
           signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}