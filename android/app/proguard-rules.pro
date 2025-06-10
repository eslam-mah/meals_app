# Keep Supabase classes
-keepattributes InnerClasses
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep Supabase authentication classes
-keep class com.supabase.** { *; }
-keep class io.gotrue.** { *; }
-keep class org.bouncycastle.** { *; }

# Keep Gson related classes
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Keep Retrofit related classes
-keep class retrofit2.** { *; }
-keepattributes Signature, Exceptions

# Keep Okhttp related classes
-keepattributes Signature
-keepattributes *Annotation*
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# Keep Play Core classes
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep network-related classes
-keep class java.net.** { *; }
-keep class javax.net.** { *; }
-keep class android.net.** { *; }
-dontwarn java.net.**
-dontwarn javax.net.**
-dontwarn android.net.** 