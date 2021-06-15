package com.example.app_center

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AppCenter.start(
            getApplication(), "d660c452-b605-4b3e-8465-cd7019e2eadb",
            Analytics::class.java, Crashes::class.java
        )
    }
}
