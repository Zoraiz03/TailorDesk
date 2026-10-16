import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val releaseRequested = gradle.startParameter.taskNames.any {
    it.contains("release", ignoreCase = true)
}
val configuredApplicationId = providers.gradleProperty("tailordeskApplicationId").orNull
val configuredAppLabel = providers.gradleProperty("tailordeskAppLabel").orNull
val signingPropertiesPath = providers.gradleProperty("tailordeskSigningProperties").orNull
val signingProperties = Properties()

if (signingPropertiesPath != null) {
    val propertiesFile = file(signingPropertiesPath)
    require(propertiesFile.isAbsolute) {
        "tailordeskSigningProperties must be an absolute path outside the repository."
    }
    require(!propertiesFile.toPath().normalize().startsWith(rootProject.projectDir.parentFile.toPath().normalize())) {
        "Android signing credentials must be stored outside the repository."
    }
    require(propertiesFile.isFile) { "Android signing properties file was not found." }
    propertiesFile.inputStream().use(signingProperties::load)
}

if (releaseRequested) {
    require(signingPropertiesPath != null) {
        "Release signing is not configured. Pass -PtailordeskSigningProperties=/absolute/outside-repo/path.properties."
    }
    require(!configuredApplicationId.isNullOrBlank() && !configuredApplicationId.startsWith("com.example.")) {
        "A non-placeholder release application ID is required via -PtailordeskApplicationId."
    }
    if (providers.gradleProperty("tailordeskNonProductionRelease").orNull == "true") {
        require(!configuredAppLabel.isNullOrBlank() && configuredAppLabel.contains("Preview")) {
            "Non-production releases require a visible Preview app label."
        }
    }
}

android {
    namespace = "com.example.tailor"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Debug builds retain Flutter's placeholder identity. Every release
        // build must supply the owner's permanent ID (or an isolated Stage 11
        // test ID) with -PtailordeskApplicationId.
        applicationId = configuredApplicationId ?: "com.example.tailor"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["appLabel"] = configuredAppLabel ?: "TailorDesk"
    }

    signingConfigs {
        if (signingPropertiesPath != null) {
            create("release") {
                val keystorePath = signingProperties.getProperty("storeFile")
                require(!keystorePath.isNullOrBlank()) { "storeFile is missing from signing properties." }
                val keystoreFile = file(keystorePath)
                require(keystoreFile.isAbsolute) { "storeFile must be an absolute path." }
                require(!keystoreFile.toPath().normalize().startsWith(rootProject.projectDir.parentFile.toPath().normalize())) {
                    "The Android keystore must be stored outside the repository."
                }
                require(keystoreFile.isFile) { "Android release keystore was not found." }
                storeFile = keystoreFile
                storePassword = signingProperties.getProperty("storePassword")
                    ?: error("storePassword is missing from signing properties.")
                keyAlias = signingProperties.getProperty("keyAlias")
                    ?: error("keyAlias is missing from signing properties.")
                keyPassword = signingProperties.getProperty("keyPassword")
                    ?: error("keyPassword is missing from signing properties.")
            }
        }
    }

    buildTypes {
        release {
            // Deliberately no debug-signing fallback. Release tasks fail above
            // unless an external keystore configuration is supplied.
            if (signingPropertiesPath != null) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
