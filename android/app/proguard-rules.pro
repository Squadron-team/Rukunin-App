# Keep PDF library classes
-keep class com.tom_roush.pdfbox.** { *; }
-dontwarn com.tom_roush.pdfbox.**

# Keep Excel library classes
-keep class org.apache.poi.** { *; }
-dontwarn org.apache.poi.**

# Keep file provider
-keep class androidx.core.content.FileProvider { *; }
