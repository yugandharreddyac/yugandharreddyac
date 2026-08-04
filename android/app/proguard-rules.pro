# Flutter ProGuard Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.provider.** { *; }
-keep class io.flutter.binder.** { *; }

# Firebase ProGuard Rules
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Gson / Jackson serialization
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod

# Prevent shrinking of generated Dart plugin registrations
-keep class * implements io.flutter.embedding.engine.plugins.FlutterPlugin { *; }
