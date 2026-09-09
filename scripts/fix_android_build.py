import os

base = r'c:\Users\caine\Downloads\LATIN_LEARN\latin_learn\ludus_latinus_mobile'

# 1. android/settings.gradle
settings_gradle = """pluginManagement {
    def flutterSdkPath = {
        def properties = new Properties()
        file("local.properties").withInputStream { properties.load(it) }
        def flutterSdkPath = properties.getProperty("flutter.sdk")
        assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
        return flutterSdkPath
    }
    settings.ext.flutterSdkPath = flutterSdkPath()

    includeBuild("${settings.ext.flutterSdkPath}/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.3.2" apply false
    id "org.jetbrains.kotlin.android" version "1.9.24" apply false
}

include ":app"
"""

with open(os.path.join(base, 'android', 'settings.gradle'), 'w', encoding='utf-8', newline='\n') as f:
    f.write(settings_gradle)

# 2. android/build.gradle
build_gradle = """allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = "../build"
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
"""

with open(os.path.join(base, 'android', 'build.gradle'), 'w', encoding='utf-8', newline='\n') as f:
    f.write(build_gradle)

# 3. android/gradle.properties
gradle_properties = """org.gradle.jvmargs=-Xmx4G
android.useAndroidX=true
android.enableJetifier=true
"""

with open(os.path.join(base, 'android', 'gradle.properties'), 'w', encoding='utf-8', newline='\n') as f:
    f.write(gradle_properties)

# 4. android/gradle/wrapper/gradle-wrapper.properties
wrapper_dir = os.path.join(base, 'android', 'gradle', 'wrapper')
os.makedirs(wrapper_dir, exist_ok=True)
wrapper_properties = """distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\\://services.gradle.org/distributions/gradle-8.4-bin.zip
"""

with open(os.path.join(wrapper_dir, 'gradle-wrapper.properties'), 'w', encoding='utf-8', newline='\n') as f:
    f.write(wrapper_properties)

# 5. android/app/build.gradle
app_build_gradle = """plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}

def localProperties = new Properties()
def localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader("UTF-8") { reader ->
        localProperties.load(reader)
    }
}

def flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
def flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

android {
    namespace "com.luduslatinus.app"
    compileSdk 34
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    sourceSets {
        main.java.srcDirs += "src/main/kotlin"
    }

    defaultConfig {
        applicationId "com.luduslatinus.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source "../.."
}

dependencies {}
"""

with open(os.path.join(base, 'android', 'app', 'build.gradle'), 'w', encoding='utf-8', newline='\n') as f:
    f.write(app_build_gradle)

# 6. android/app/src/main/AndroidManifest.xml
manifest = """<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <application
        android:label="Ludus Latinus"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@android:style/Theme.Light.NoTitleBar"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@android:style/Theme.Light.NoTitleBar"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
"""

with open(os.path.join(base, 'android', 'app', 'src', 'main', 'AndroidManifest.xml'), 'w', encoding='utf-8', newline='\n') as f:
    f.write(manifest)

print("Successfully fixed all Android files without BOM!")
