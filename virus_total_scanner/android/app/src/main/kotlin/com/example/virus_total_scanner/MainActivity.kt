package com.example.virus_total_scanner

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.RequestBody.Companion.asRequestBody
import okhttp3.RequestBody.Companion.toRequestBody
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
                    println("Kotlin received URL: $url")
                    if (url != null) {
                        scanUrlWithVirusTotal(url, result)
                    } else {
                        result.error("MISSING_URL", "URL argument is missing on native side", null)
                    }
                }

                "scanFile" -> {
                    val path = call.argument<String>("filePath")
                    if (path != null) {
                        scanFileWithVirusTotal(path, result)
                    }
                }
"getFileReport" -> {
    val hash = call.argument<String>("hash")
    if (hash != null) {
        getFileReport(hash, result)
    } else {
        result.error("MISSING_HASH", "SHA256 is missing", null)
    }
}
 // ✅ هذا هو الجزء الذي تحتاج تضيفه
            	"getAnalysis" -> {
                	val id = call.argument<String>("id")
                	if (id != null) {
                    	getAnalysisResult(id, result)
                	} else {
                    	result.error("MISSING_ID", "Analysis ID is missing", null)
                }
            }

            else -> result.notImplemented()
        }
    }
}
private fun getFileReport(sha256: String, result: MethodChannel.Result) {
    val apiKey = "YOUR_API_KEY"
    val client = OkHttpClient()

    val request = Request.Builder()
        .url("https://www.virustotal.com/api/v3/files/$sha256")
        .addHeader("x-apikey", apiKey)
        .get()
        .build()

    client.newCall(request).enqueue(object : Callback {
        override fun onFailure(call: Call, e: IOException) {
            result.error("ERROR", e.message, null)
        }

        override fun onResponse(call: Call, response: Response) {
            val body = response.body?.string()
            result.success(body)
        }
    })
}
   private fun scanUrlWithVirusTotal(url: String, result: MethodChannel.Result) {
    val apiKey = "a90376316088396b21b6c0d7f5e4cc36746f63077e1ec47890226d402ac9d2c0"
    val client = OkHttpClient()

    val requestBody = "url=$url".toRequestBody("application/x-www-form-urlencoded".toMediaTypeOrNull())

    val request = Request.Builder()
        .url("https://www.virustotal.com/api/v3/urls")
        .addHeader("x-apikey", apiKey)
        .post(requestBody)
        .build()

    client.newCall(request).enqueue(object : Callback {
        override fun onFailure(call: Call, e: IOException) {
            result.error("ERROR", e.message, null)
        }

        override fun onResponse(call: Call, response: Response) {
            val resBody = response.body?.string()
            val jsonResponse = JSONObject(resBody ?: "{}")

            val analysisId = jsonResponse.optJSONObject("data")?.optString("id")

            if (analysisId != null) {
                fetchUrlAnalysisReport(apiKey, client, analysisId, result)
            } else {
                result.success(resBody) // fallback
            }
        }
    })
}


    private fun fetchUrlAnalysisReport(
        apiKey: String,
        client: OkHttpClient,
        analysisId: String,
        result: MethodChannel.Result
    ) {
        val request = Request.Builder()
            .url("https://www.virustotal.com/api/v3/analyses/$analysisId")
            .addHeader("x-apikey", apiKey)
            .get()
            .build()

        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                result.error("ERROR", e.message, null)
            }

            override fun onResponse(call: Call, response: Response) {
                val fullReport = response.body?.string()
                result.success(fullReport)
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
            val jsonResponse = JSONObject(resBody ?: "{}")
            val analysisId = jsonResponse.optJSONObject("data")?.optString("id")

            if (!analysisId.isNullOrEmpty()) {
                // ✅ تأخير 3 ثوانٍ ثم طلب النتيجة
                Thread.sleep(3000)
                getAnalysisResult(analysisId, result)
            } else {
                result.error("NO_ANALYSIS_ID", "No analysis ID received", null)
            }
        }
    })
}


private fun getAnalysisResult(analysisId: String, result: MethodChannel.Result) {
    val apiKey = "a90376316088396b21b6c0d7f5e4cc36746f63077e1ec47890226d402ac9d2c0"
    val client = OkHttpClient()

    val request = Request.Builder()
        .url("https://www.virustotal.com/api/v3/analyses/$analysisId")
        .addHeader("x-apikey", apiKey)
        .get()
        .build()

    client.newCall(request).enqueue(object : Callback {
        override fun onFailure(call: Call, e: IOException) {
            result.error("ERROR", e.message, null)
        }

        override fun onResponse(call: Call, response: Response) {
            val fullReport = response.body?.string()
            result.success(fullReport)
        }
    })
}
}
