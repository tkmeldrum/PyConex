int val = 0;
long startTime = 0;
long endTime = 0;
long pulseTime = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  for (int pinCheck = 2; pinCheck <=13; pinCheck++) {
    val = digitalRead(pinCheck);
//    if (val == 1) {
    Serial.print(pinCheck);
    Serial.print(", ");
    Serial.print(val);
    Serial.println();
    delay(200);
//    }
//    if (val != 0) {
//      unsigned long startTime = millis();
//      while (val != 0) {
//        val = digitalRead(pinCheck);
//      }
//      unsigned long endTime = millis();
//      pulseTime = endTime - startTime;
//      if (pulseTime >= 10) {
////      Serial.write(" GO TO NEXT\n");
//        Serial.print(pinCheck);
//        Serial.print(pulseTime);
//        Serial.println();
//      }
//    }
  }
}
