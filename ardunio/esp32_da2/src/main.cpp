#include <Wire.h>
#include <TinyGPS.h>
#include <WiFi.h>

WiFiClient client;

const char* ssid = "42.19UVK";
const char* password = "42.19Uvk@@";
const char* server = "192.168.7.132";
const int port = 8000;
const int sendingInterval = 15000;

TinyGPS gps;

void connectToWiFi() {
  Serial.println("Connecting to WiFi");

  WiFi.begin(ssid, password);

  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 50) {
    delay(1000);
    Serial.print(".");
    attempts++;
  }

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\nWiFi connected");
  } else {
    Serial.println("\nFailed to connect to WiFi. Check your credentials.");
    delay(5000);  // Đợi 5 giây trước khi thử lại
  }
}

void setup() {
  Serial.begin(115200);
  connectToWiFi();
}

void loop() {
  if (WiFi.status() != WL_CONNECTED) {
    connectToWiFi();
    return;
  }

  // Tạo dữ liệu GPS ngẫu nhiên
  float lat = 10.80789 + random(-100, 100) / 1000.0;  // Range: -90 to 90
  float lon = 106.424698 + random(-200, 200) / 1000.0;   // Range: -180 to 180

  if (client.connect(server, port)) {
    // Gửi dữ liệu lên server
    String req_uri = "/update?lat=" + String(lat, 6) + "&lon=" + String(lon, 6);
    String request = "GET " + req_uri + " HTTP/1.1\r\n" +
                     "Host: " + server + "\r\n" +
                     "Connection: close\r\n" +
                     "Content-Length: 0\r\n" +
                     "\r\n";
    client.print(request);

    // In ra Serial thông tin đã gửi
    Serial.printf("Latitude: %s - Longitude: %s\r\n",
                  String(lat, 6).c_str(), String(lon, 6).c_str());
  } else {
    Serial.println("Failed to connect to server!");
  }

  client.stop();

  delay(sendingInterval);
}
