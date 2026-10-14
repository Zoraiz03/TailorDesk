package com.example.tailor

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.Activity
import android.content.Intent
import android.os.Build

class MainActivity : FlutterActivity() {
    private var pendingSave: MethodChannel.Result? = null
    private var pendingBytes: ByteArray? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "tailordesk/delivery")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "appVersion" -> {
                        val info = packageManager.getPackageInfo(packageName, 0)
                        val code = if (Build.VERSION.SDK_INT >= 28) info.longVersionCode else info.versionCode.toLong()
                        result.success("${info.versionName} ($code)")
                    }
                    "saveActivationRequest" -> {
                        val bytes = call.argument<ByteArray>("bytes")
                        if (pendingSave != null || bytes == null || bytes.size > 4096) {
                            result.error("unavailable", "Cannot start request export.", null)
                        } else {
                            pendingSave = result
                            pendingBytes = bytes
                            try {
                                startActivityForResult(Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                                    addCategory(Intent.CATEGORY_OPENABLE)
                                    type = "application/json"
                                    putExtra(Intent.EXTRA_TITLE, "tailordesk-activation-request.json")
                                }, 1201)
                            } catch (error: Exception) {
                                pendingSave = null
                                pendingBytes = null
                                result.error("save_failed", "Could not open save chooser.", null)
                            }
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != 1201) return
        val result = pendingSave ?: return
        val bytes = pendingBytes
        pendingSave = null
        pendingBytes = null
        if (resultCode != Activity.RESULT_OK) {
            result.success(false)
            return
        }
        try {
            val uri = data?.data ?: error("Missing destination")
            requireNotNull(bytes)
            val stream = contentResolver.openOutputStream(uri, "wt") ?: error("Cannot open destination")
            stream.use { it.write(bytes) }
            result.success(true)
        } catch (error: Exception) {
            result.error("save_failed", "Could not save activation request.", null)
        }
    }
}
