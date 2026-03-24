# Keep Flutter embedding and plugins reachable while allowing R8 to shrink
# otherwise-unused Android-side code.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
