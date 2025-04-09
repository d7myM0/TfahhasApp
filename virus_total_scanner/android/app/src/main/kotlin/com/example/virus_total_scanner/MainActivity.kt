package com.example.virus_total_scanner

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.RequestBody.Companion.asRequestBody
import org.json.JSONObject
import java.io.File
import java.io.IOException

class MainActivity : FlutterActivity() {
    private val CHANNEL = "virustotal.channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "scanUrl" -> {
                    val url = call.argument<String>("url")
                    if (url != null) {
                        scanUrlWithVirusTotal(url, result)
                    }
                }

                "scanFile" -> {
                    val path = call.argument<String>("filePath")
                    if (path != null) {
                        scanFileWithVirusTotal(path, result)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun scanUrlWithVirusTotal(url: String, result: MethodChannel.Result) {
        val apiKey = "a90376316088396b21b6c0d7f5e4cc36746f63077e1ec47890226d402ac9d2c0"
        val client = OkHttpClient()
        val json = JSONObject()
        json.put("url", url)

        val body = RequestBody.create("application/json".toMediaTypeOrNull(), json.toString())
        val request = Request.Builder()
            .url("https://www.virustotal.com/api/v3/urls")
            .addHeader("x-apikey", apiKey)
            .post(body)
            .build()

        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                result.error("ERROR", e.message, null)
            }

            override fun onResponse(call: Call, response: Response) {
                val resBody = response.body?.string()
                result.success(resBody)
            }
        })
    }

    private fun scanFileWithVirusTotal(filePath: String, result: MethodChannel.Result) {
        val apiKey = "a90376316088396b21b6c0d7f5e4cc36746f63077e1ec47890226d402ac9d2c0"
        val client = OkHttpClient()
        val file = File(filePath)

        val requestBody = MultipartBody.Builder()
            .setType(MultipartBody.FORM)
            .addFormDataPart("file", file.name, file.asRequestBody())
            .build()

        val request = Request.Builder()
            .url("https://www.virustotal.com/api/v3/files")
            .addHeader("x-apikey", apiKey)
            .post(requestBody)
            .build()

        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                result.error("ERROR", e.message, null)
            }

            override fun onResponse(call: Call, response: Response) {
                val resBody = response.body?.string()
                result.success(resBody)
            }
        })
    }
}
