from flask import Flask, request, jsonify
from flask_cors import CORS
import requests

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
    response = requests.post(f"{VT_BASE_URL}/files", files=files, headers=headers)

    return jsonify(response.json())

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000)
