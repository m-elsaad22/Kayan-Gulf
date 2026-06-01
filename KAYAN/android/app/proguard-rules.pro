# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Stripe
-keep class com.stripe.android.** { *; }

# Hive
-keep class com.hive.** { *; }

# Keep all annotations
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
