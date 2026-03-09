package com.rakhul.unfilter

import android.content.pm.ApplicationInfo
import java.io.File
import java.io.InputStream
import java.util.zip.ZipFile

class StackDetector {

    private val KOTLIN_METADATA_BYTES = "Lkotlin/Metadata;".toByteArray(Charsets.UTF_8)
    private val COMPOSE_MARKER_BYTES = "Landroidx/compose/ui/".toByteArray(Charsets.UTF_8)
    private val WEBVIEW_PLUGINS_MARKERS = listOf(
        "Lio/flutter/plugins/webviewflutter/".toByteArray(Charsets.UTF_8),
        "Lcom/pichillilorenzo/flutter_inappwebview/".toByteArray(Charsets.UTF_8)
    )

    fun detectStackAndLibs(appInfo: ApplicationInfo, preOpenedZip: ZipFile? = null): Pair<String, List<String>> {
        val apkPath = appInfo.sourceDir
        if (apkPath == null || !File(apkPath).exists()) {
            return Pair("Unknown", emptyList())
        }
        
        val apkPaths = mutableListOf<String>()
        apkPaths.add(apkPath)
        appInfo.splitSourceDirs?.let { apkPaths.addAll(it) }

        val libs = mutableSetOf<String>()
        var isKotlin = false
        
        var hasFlutterAssets = false
        var hasReactNativeBundle = false
        var hasXamarin = false
        var hasIonic = false
        var hasUnity = false
        var hasGodot = false
        var hasCapacitor = false
        var hasCordova = false
        var hasNativeScript = false
        var hasCorona = false
        var hasWebAssets = false



        for (path in apkPaths) {
            val file = File(path)
            if (!file.exists() || !file.canRead()) continue

            try {
                if (preOpenedZip != null && path == apkPath) {
                    scanZipEntries(preOpenedZip, libs) { k -> isKotlin = k }
                        .let { res ->
                            if (res.hasFlutterAssets) hasFlutterAssets = true
                            if (res.hasReactNativeBundle) hasReactNativeBundle = true
                            if (res.hasXamarin) hasXamarin = true
                            if (res.hasIonic) hasIonic = true
                            if (res.hasUnity) hasUnity = true
                            if (res.hasGodot) hasGodot = true
                            if (res.hasCapacitor) hasCapacitor = true
                            if (res.hasCordova) hasCordova = true
                            if (res.hasNativeScript) hasNativeScript = true
                            if (res.hasCorona) hasCorona = true
                            if (res.hasWebAssets) hasWebAssets = true

                            if (res.isKotlin) isKotlin = true
                        }
                } else {
                    ZipFile(file).use { zip ->
                        scanZipEntries(zip, libs) { k -> isKotlin = k }
                            .let { res ->
                                if (res.hasFlutterAssets) hasFlutterAssets = true
                                if (res.hasReactNativeBundle) hasReactNativeBundle = true
                                if (res.hasXamarin) hasXamarin = true
                                if (res.hasIonic) hasIonic = true
                                if (res.hasUnity) hasUnity = true
                                if (res.hasGodot) hasGodot = true
                                if (res.hasCapacitor) hasCapacitor = true
                                if (res.hasCordova) hasCordova = true
                                if (res.hasNativeScript) hasNativeScript = true
                                if (res.hasCorona) hasCorona = true
                                if (res.hasWebAssets) hasWebAssets = true

                                if (res.isKotlin) isKotlin = true
                            }
                    }
                }
            } catch (e: Exception) {
            }
        }

        var stack = "Native"
        if (libs.contains("flutter") || hasFlutterAssets) {
            stack = "Flutter"
            if (hasWebAssets) {
                stack = "Flutter (Hybrid)"
            } else {
                // Check for high-signal WebView plugins
                var hasWebViewPlugin = false
                for (marker in WEBVIEW_PLUGINS_MARKERS) {
                    if (deepScanForString(apkPaths, marker, preOpenedZip)) {
                        hasWebViewPlugin = true
                        break
                    }
                }
                
                if (hasWebViewPlugin) {
                    // If it has a dedicated WebView plugin but NO local assets, 
                    // it's almost certainly a Remote WebView Wrapper.
                    stack = "Flutter (WebView wrapper)"
                }
            }
        }
        else if (libs.contains("reactnativejni") || libs.contains("hermes") || hasReactNativeBundle) stack = "React Native"
        else if (libs.contains("unity") || hasUnity) stack = "Unity"
        else if (libs.contains("godot_android") || hasGodot) stack = "Godot"
        else if (hasXamarin) stack = "Xamarin"
        else if (hasNativeScript) stack = "NativeScript"
        else if (hasCapacitor) stack = "Capacitor"
        else if (hasIonic) stack = "Ionic"
        else if (hasCordova) stack = "Cordova"
        else if (hasCorona) stack = "Corona"
        
        if (stack == "Native") {
            if (isKotlin) {
                if (deepScanForString(apkPaths, COMPOSE_MARKER_BYTES, preOpenedZip)) {
                     stack = "Jetpack"
                } else {
                     stack = "Kotlin"
                }
            } else {
                if (deepScanForString(apkPaths, KOTLIN_METADATA_BYTES, preOpenedZip)) {
                     if (deepScanForString(apkPaths, COMPOSE_MARKER_BYTES, preOpenedZip)) {
                         stack = "Jetpack"
                     } else {
                         stack = "Kotlin"
                     }
                } else {
                    stack = "Java"
                }
            }
        }

        return Pair(stack, libs.toList())
    }

    data class ScanResult(
        var isKotlin: Boolean = false,
        var hasFlutterAssets: Boolean = false,
        var hasReactNativeBundle: Boolean = false,
        var hasXamarin: Boolean = false,
        var hasIonic: Boolean = false,
        var hasUnity: Boolean = false,
        var hasGodot: Boolean = false,
        var hasCapacitor: Boolean = false,
        var hasCordova: Boolean = false,
        var hasNativeScript: Boolean = false,
        var hasCorona: Boolean = false,
        var hasWebAssets: Boolean = false
    )

    private fun scanZipEntries(zip: ZipFile, libs: MutableSet<String>, setKotlin: (Boolean) -> Unit): ScanResult {
        val result = ScanResult()
        
        val entries = zip.entries()
        while (entries.hasMoreElements()) {
            val entry = entries.nextElement()
            val name = entry.name
            
            if (!result.isKotlin) {
                if (name.endsWith(".kotlin_module") || 
                    name.startsWith("kotlin/") || 
                    name.startsWith("META-INF/services/kotlin") ||
                    name.startsWith("META-INF/kotlin") ||
                    name.endsWith(".kotlin_builtins")) {
                    result.isKotlin = true
                }
            }

            if (name.startsWith("lib/") && name.endsWith(".so")) {
                val parts = name.split("/")
                if (parts.isNotEmpty()) {
                    val fileName = parts.last()
                    if (fileName.startsWith("lib") && fileName.endsWith(".so")) {
                        val libName = fileName.substring(3, fileName.length - 3)
                        libs.add(libName)
                    }
                }
            }

            if (name.contains("flutter_assets") || name.endsWith("libapp.so") || name.endsWith("app.so")) result.hasFlutterAssets = true
            else if (name.contains("index.android.bundle")) result.hasReactNativeBundle = true
            else if (name.contains("libmonodroid.so") || name.contains("assemblies/Mono.Android.dll")) result.hasXamarin = true
            else if (name.contains("ionic.js") || name.contains("ionic.css") || name.contains("ionicons")) result.hasIonic = true
            else if (name.contains("libgodot_android.so")) result.hasGodot = true
            else if (name.contains("libunity.so")) result.hasUnity = true
            else if (name.endsWith("capacitor.config.json") || name.contains("public/capacitor.js")) result.hasCapacitor = true
            else if (name.contains("www/cordova.js")) result.hasCordova = true
            else if (name.contains("libNativeScript.so") || name.contains("app/tns_modules")) result.hasNativeScript = true
             else if (name.contains("libcorona.so") || name.endsWith("main.lua")) result.hasCorona = true

            if (name.endsWith("index.html") && name.contains("assets/")) {
                result.hasWebAssets = true
            }
            // Additional check for JS/CSS in assets but outside standard flutter patterns
            if ((name.endsWith(".js") || name.endsWith(".css")) && 
                !name.contains("flutter_assets/") && 
                name.contains("assets/") && 
                !name.contains("META-INF/") &&
                !name.contains("google/")) {
                result.hasWebAssets = true
            }
        }
        return result
    }

    private fun deepScanForString(apkPaths: List<String>, pattern: ByteArray, preOpenedZip: ZipFile? = null): Boolean {
        for (path in apkPaths) {
            val file = File(path)
            if (!file.exists()) continue
            
            try {
                if (preOpenedZip != null && path == apkPaths[0]) {
                    if (scanZipForBytes(preOpenedZip, pattern)) return true
                } else {
                    ZipFile(file).use { zip ->
                        if (scanZipForBytes(zip, pattern)) return true
                    }
                }
            } catch (e: Exception) { 
            }
        }
        return false
    }

    private fun scanZipForBytes(zip: ZipFile, pattern: ByteArray): Boolean {
        val entries = zip.entries()
        while (entries.hasMoreElements()) {
            val entry = entries.nextElement()
            if (entry.name.endsWith(".dex")) {
                 zip.getInputStream(entry).use { stream ->
                     if (scanStreamForBytes(stream, pattern)) {
                         return true
                     }
                 }
            }
        }
        return false
    }

    private fun scanStreamForBytes(stream: InputStream, pattern: ByteArray): Boolean {
        val bufferSize = 64 * 1024
        val buffer = ByteArray(bufferSize)
        var bytesRead: Int
        
        val tailSize = pattern.size - 1
        var carryOverLength = 0
        
        while (stream.read(buffer, carryOverLength, bufferSize - carryOverLength).also { bytesRead = it } != -1) {
            val validBytes = carryOverLength + bytesRead
            
            if (indexOf(buffer, validBytes, pattern) != -1) {
                return true
            }

            if (validBytes >= tailSize) {
                System.arraycopy(buffer, validBytes - tailSize, buffer, 0, tailSize)
                carryOverLength = tailSize
            } else {
                carryOverLength = validBytes
            }
        }
        return false
    }
    
    private fun indexOf(data: ByteArray, length: Int, pattern: ByteArray): Int {
        if (pattern.isEmpty()) return 0
        if (length < pattern.size) return -1

        val firstByte = pattern[0]
        val maxI = length - pattern.size

        for (i in 0..maxI) {
            if (data[i] != firstByte) continue
            
            var found = true
            for (j in 1 until pattern.size) {
                if (data[i + j] != pattern[j]) {
                    found = false
                    break
                }
            }
            if (found) return i
        }
        return -1
    }
}
