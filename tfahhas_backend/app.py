from flask import Flask, request, jsonify
from flask_cors import CORS
import requests
import time  # يجب إضافتها


app = Flask(__name__)
CORS(app)

VT_API_KEY = "a90376316088396b21b6c0d7f5e4cc36746f63077e1ec47890226d402ac9d2c0"
VT_BASE_URL = "https://www.virustotal.com/api/v3"

@app.route("/scan-url", methods=["POST"])
def scan_url():
    data = request.get_json()
    url = data.get("url")
    if not url:
        return jsonify({"error": "Missing URL"}), 400

    headers = {
        "x-apikey": VT_API_KEY,
        "Content-Type": "application/x-www-form-urlencoded"
    }
    response = requests.post(f"{VT_BASE_URL}/urls", data=f"url={url}", headers=headers)
    result = response.json()
    analysis_id = result.get("data", {}).get("id")

    if not analysis_id:
        return jsonify(result), 500

    report = requests.get(f"{VT_BASE_URL}/analyses/{analysis_id}", headers=headers)
    return jsonify(report.json())

@app.route("/scan-file", methods=["POST"])
def scan_file():
    if "file" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400

    file = request.files["file"]

    headers = {"x-apikey": VT_API_KEY}
    files = {"file": (file.filename, file.stream, file.mimetype)}

    # 1. رفع الملف
    upload_response = requests.post(f"{VT_BASE_URL}/files", files=files, headers=headers)
    if upload_response.status_code != 200:
        return jsonify({"error": "Failed to upload file"}), 500

    upload_data = upload_response.json()
    analysis_id = upload_data.get("data", {}).get("id")
    if not analysis_id:
        return jsonify({"error": "No analysis ID returned"}), 500

    # 2. الانتظار (إجباري في حالة VirusTotal)
    time.sleep(8)

    # 3. طلب التحليل النهائي
    analysis_response = requests.get(f"{VT_BASE_URL}/analyses/{analysis_id}", headers=headers)
    return jsonify(analysis_response.json())