import java.io.FileInputStream
import java.util.Properties


plugins {

    id("com.android.application")

    id("org.jetbrains.kotlin.android")

    id("dev.flutter.flutter-gradle-plugin")

}



val keystoreProperties = Properties()

val keystorePropertiesFile = rootProject.file("key.properties")


if (keystorePropertiesFile.exists()) {

    keystoreProperties.load(

        FileInputStream(keystorePropertiesFile)

    )

}





android {

    namespace = "ir.sabtino.app"

    compileSdk = flutter.compileSdkVersion

    ndkVersion = flutter.ndkVersion



    compileOptions {

        sourceCompatibility = JavaVersion.VERSION_17

        targetCompatibility = JavaVersion.VERSION_17

    }



    signingConfigs {


        create("release") {


            keyAlias = keystoreProperties["keyAlias"] as String


            keyPassword = keystoreProperties["keyPassword"] as String


            storeFile = file(

                keystoreProperties["storeFile"] as String

            )


            storePassword = keystoreProperties["storePassword"] as String


        }


    }





    defaultConfig {


        applicationId = "ir.sabtino.app"


        minSdk = flutter.minSdkVersion

        targetSdk = flutter.targetSdkVersion


        versionCode = flutter.versionCode

        versionName = flutter.versionName


    }





    buildTypes {


        debug {


            signingConfig = signingConfigs.getByName("debug")


        }



        release {


            signingConfig = signingConfigs.getByName("release")


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