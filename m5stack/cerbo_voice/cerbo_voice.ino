/*
 * Cerbo GX AI Voice Assistant - M5Stack StickC S3
 * Uses M5Unified built-in mic support
 * Hold A: Record voice -> AI responds
 * Short press A: Ask preset question
 * Press B: Cycle questions
 */

#include <M5Unified.h>
#include <WiFi.h>
#include <HTTPClient.h>

const char* ssid = "LIBBY LINDLEY WIFI";
const char* password = "Chez140919";
const char* askUrl = "http://192.168.86.196:8085/ask";
const char* voiceUrl = "http://192.168.86.196:8085/voice";

#define SAMPLE_RATE  16000
#define RECORD_SECS  5
#define SAMPLE_COUNT (SAMPLE_RATE * RECORD_SECS)

int16_t* recBuffer = NULL;
bool processing = false;
int questionIndex = 0;

const char* questions[] = {
    "How is my battery doing right now?",
    "How is my solar performing?",
    "Should I charge now based on the Agile price?",
    "Give me energy saving tips.",
    "What is the current electricity price?"
};
const int numQuestions = 5;
const char* labels[] = {"Battery?", "Solar?", "Charge?", "Tips?", "Price?"};

void displayText(const char* text, uint32_t color = TFT_WHITE) {
    M5.Display.fillScreen(TFT_BLACK);
    M5.Display.setTextColor(color);
    M5.Display.setTextSize(2);
    M5.Display.setCursor(0, 0);
    M5.Display.setTextWrap(true);
    M5.Display.print(text);
}

void displayMenu() {
    M5.Display.fillScreen(TFT_BLACK);
    M5.Display.setTextColor(TFT_CYAN);
    M5.Display.setTextSize(2);
    M5.Display.setCursor(0, 0);
    M5.Display.println("CerboAI");
    M5.Display.setTextColor(TFT_YELLOW);
    M5.Display.println(labels[questionIndex]);
    M5.Display.setTextColor(TFT_GREEN);
    M5.Display.println("Hold:Voice");
    M5.Display.setTextColor(TFT_WHITE);
    M5.Display.print("B:Next");
}

void writeWavHeader(uint8_t* buf, int dataSize) {
    int fileSize = dataSize + 36;
    memcpy(buf, "RIFF", 4);
    buf[4] = fileSize & 0xFF; buf[5] = (fileSize >> 8) & 0xFF;
    buf[6] = (fileSize >> 16) & 0xFF; buf[7] = (fileSize >> 24) & 0xFF;
    memcpy(buf + 8, "WAVE", 4);
    memcpy(buf + 12, "fmt ", 4);
    buf[16] = 16; buf[17] = 0; buf[18] = 0; buf[19] = 0;
    buf[20] = 1; buf[21] = 0; // PCM
    buf[22] = 1; buf[23] = 0; // mono
    int sr = SAMPLE_RATE;
    buf[24] = sr & 0xFF; buf[25] = (sr >> 8) & 0xFF;
    buf[26] = (sr >> 16) & 0xFF; buf[27] = (sr >> 24) & 0xFF;
    int byteRate = sr * 2;
    buf[28] = byteRate & 0xFF; buf[29] = (byteRate >> 8) & 0xFF;
    buf[30] = (byteRate >> 16) & 0xFF; buf[31] = (byteRate >> 24) & 0xFF;
    buf[32] = 2; buf[33] = 0;
    buf[34] = 16; buf[35] = 0;
    memcpy(buf + 36, "data", 4);
    buf[40] = dataSize & 0xFF; buf[41] = (dataSize >> 8) & 0xFF;
    buf[42] = (dataSize >> 16) & 0xFF; buf[43] = (dataSize >> 24) & 0xFF;
}

bool recordAudio() {
    if (!M5.Mic.isEnabled()) {
        displayText("No mic!", TFT_RED);
        delay(2000);
        return false;
    }

    M5.Mic.begin();
    
    // Record in chunks
    int samplesPerChunk = 1024;
    int totalRecorded = 0;
    
    while (totalRecorded < SAMPLE_COUNT) {
        int toRecord = min(samplesPerChunk, SAMPLE_COUNT - totalRecorded);
        if (M5.Mic.record(&recBuffer[totalRecorded], toRecord, SAMPLE_RATE)) {
            totalRecorded += toRecord;
        }
        delay(1);
    }
    
    M5.Mic.end();
    return true;
}

String sendVoice() {
    int dataSize = SAMPLE_COUNT * 2;
    int wavSize = 44 + dataSize;
    uint8_t* wavBuf = (uint8_t*)ps_malloc(wavSize);
    if (!wavBuf) {
        wavBuf = (uint8_t*)malloc(wavSize);
    }
    if (!wavBuf) return "Memory error";

    writeWavHeader(wavBuf, dataSize);
    memcpy(wavBuf + 44, recBuffer, dataSize);

    HTTPClient http;
    http.begin(voiceUrl);
    http.addHeader("Content-Type", "audio/wav");
    http.setTimeout(30000);

    int httpCode = http.POST(wavBuf, wavSize);
    free(wavBuf);

    String response = "";
    if (httpCode == 200) {
        String body = http.getString();
        int idx = body.indexOf("\"answer\":");
        if (idx >= 0) {
            int start = body.indexOf("\"", idx + 9) + 1;
            int end = start;
            while (end < body.length()) {
                if (body[end] == '\"' && body[end - 1] != '\\') break;
                end++;
            }
            response = body.substring(start, end);
            response.replace("\\n", "\n");
            response.replace("\\\"", "\"");
        } else {
            response = body.substring(0, 200);
        }
    } else {
        response = "Err:" + String(httpCode);
    }
    http.end();
    return response;
}

String askQuestion(const char* question) {
    HTTPClient http;
    http.begin(askUrl);
    http.addHeader("Content-Type", "application/json");
    http.setTimeout(30000);

    String payload = "{\"question\":\"";
    payload += question;
    payload += "\"}";

    int httpCode = http.POST(payload);
    String response = "";

    if (httpCode == 200) {
        String body = http.getString();
        int idx = body.indexOf("\"answer\":");
        if (idx >= 0) {
            int start = body.indexOf("\"", idx + 9) + 1;
            int end = start;
            while (end < body.length()) {
                if (body[end] == '\"' && body[end - 1] != '\\') break;
                end++;
            }
            response = body.substring(start, end);
            response.replace("\\n", "\n");
            response.replace("\\\"", "\"");
        }
    } else {
        response = "Err:" + String(httpCode);
    }
    http.end();
    return response;
}

void setup() {
    auto cfg = M5.config();
    M5.begin(cfg);
    M5.Display.setRotation(1);
    M5.Power.setExtOutput(true);

    displayText("WiFi...", TFT_YELLOW);

    WiFi.begin(ssid, password);
    int attempts = 0;
    while (WiFi.status() != WL_CONNECTED && attempts < 20) {
        delay(500);
        attempts++;
    }

    if (WiFi.status() == WL_CONNECTED) {
        displayText("WiFi OK!", TFT_GREEN);
    } else {
        displayText("WiFi FAIL", TFT_RED);
        delay(3000);
    }

    // Allocate recording buffer in PSRAM
    recBuffer = (int16_t*)ps_malloc(SAMPLE_COUNT * 2);
    if (!recBuffer) {
        recBuffer = (int16_t*)malloc(SAMPLE_COUNT * 2);
    }

    delay(1000);
    displayMenu();
}

void loop() {
    M5.update();
    if (processing) return;

    // Long press A = voice record
    if (M5.BtnA.wasReleaseFor(500)) {
        processing = true;
        displayText("Speak now\n5 secs...", TFT_RED);
        delay(300);

        if (recordAudio()) {
            displayText("Sending...", TFT_YELLOW);
            String response = sendVoice();

            if (response.length() > 0) {
                displayText(response.c_str(), TFT_GREEN);
            } else {
                displayText("No response", TFT_RED);
            }
        }
        // Wait for any button press to return
        while (true) {
            M5.update();
            if (M5.BtnA.wasPressed() || M5.BtnB.wasPressed()) break;
            delay(50);
        }
        displayMenu();
        processing = false;
        return;
    }

    // Short press A = preset question
    if (M5.BtnA.wasClicked()) {
        processing = true;
        displayText("Thinking..", TFT_YELLOW);

        String response = askQuestion(questions[questionIndex]);
        if (response.length() > 0) {
            displayText(response.c_str(), TFT_GREEN);
        } else {
            displayText("No response", TFT_RED);
        }
        // Wait for any button press to return
        while (true) {
            M5.update();
            if (M5.BtnA.wasPressed() || M5.BtnB.wasPressed()) break;
            delay(50);
        }
        displayMenu();
        processing = false;
    }

    // Button B = next question
    if (M5.BtnB.wasPressed()) {
        questionIndex = (questionIndex + 1) % numQuestions;
        displayMenu();
    }

    delay(50);
}
