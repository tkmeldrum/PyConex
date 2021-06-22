const int TTLPin = 9; // the pin number for the TTL input
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

  val = digitalRead(TTLPin);

  if (val != 0) {
    unsigned long startTime = millis();
    while (val != 0) {
      val = digitalRead(TTLPin);
    }
    unsigned long endTime = millis();
    pulseTime = endTime - startTime;
    if (pulseTime >= 10) {
      Serial.write(" GO TO NEXT\n");
//      Serial.println();
    }
  }
}
