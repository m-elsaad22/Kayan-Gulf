package sa.kayan.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "sa.kayan.app/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getDeviceId" -> {
                        val id = android.provider.Settings.Secure.getString(
                            contentResolver,
                            android.provider.Settings.Secure.ANDROID_ID
                        )
                        result.success(id)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
