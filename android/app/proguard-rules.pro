# Ignore missing imageio desktop classes
-dontwarn javax.imageio.**
-dontwarn com.github.jaiimageio.**

# Keep Flutter and Android app classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class androidx.** { *; }

# Fix missing Play Core splitinstall classes
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Keep Flutter-related components
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-keep class io.flutter.embedding.android.FlutterPlayStoreSplitApplication { *; }
