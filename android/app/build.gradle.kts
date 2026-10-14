import java.util.Base64
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

fun decodedDartDefines(): Map<String, String> {
    val encoded = providers.gradleProperty("dart-defines").orNull ?: return emptyMap()
    return encoded.split(',').mapNotNull { value ->
        runCatching {
            String(Base64.getDecoder().decode(value), Charsets.UTF_8)
        }.getOrNull()?.let { decoded ->
            val separator = decoded.indexOf('=')
            if (separator <= 0) null else decoded.substring(0, separator) to decoded.substring(separator + 1)
        }
    }.toMap()
}

val releaseRequested = gradle.startParameter.taskNames.any {
    it.contains("release", ignoreCase = true)
}
val dartDefines = decodedDartDefines()
val trustMode = dartDefines["TAILORDESK_LICENSE_TRUST_MODE"]
val trustedLicenseKeys = dartDefines["TAILORDESK_LICENSE_PUBLIC_KEYS"]
val configuredApplicationId = providers.gradleProperty("tailordeskApplicationId").orNull
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
    require(trustMode == "production" || trustMode == "test") {
        "Release builds require TAILORDESK_LICENSE_TRUST_MODE=production (or test for a clearly non-production verification build)."
    }
    require(!trustedLicenseKeys.isNullOrBlank() && trustedLicenseKeys != "{}") {
        "Release builds require explicit TAILORDESK_LICENSE_PUBLIC_KEYS."
    }
    if (trustMode == "production") {
        require(
            !trustedLicenseKeys.contains("\"dev-") &&
                !trustedLicenseKeys.contains("\"stage11-test")
        ) {
            "Production builds must not contain development or Stage 11 test license key IDs."
        }
    }
    if (trustMode == "test") {
        require(providers.gradleProperty("tailordeskNonProductionRelease").orNull == "true") {
            "Test trust roots require -PtailordeskNonProductionRelease=true. Never distribute this APK."
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
        manifestPlaceholders["appLabel"] = if (trustMode == "test") {
            "TailorDesk TEST — NOT FOR DISTRIBUTION"
        } else {
            "TailorDesk"
        }
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
