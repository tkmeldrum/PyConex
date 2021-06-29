//# This sample codes is for testing the RS232 shiled.
//# Editor : YouYou
//# Date   : 2013.9.25
//# Ver    : 0.1
//# Product: RS232 shield
//# SKU    : DFR0259
//*/
int led = 13;    //define the LED pin 
void setup()
{
  Serial.begin(9600);    //init serial
  pinMode(led,OUTPUT);
}
void loop()
{
  int temp;    //serial data temporary cache 
  if(Serial.available())    //if serial receives data
  {
    temp=Serial.read();    //store the received data temporarily
    Serial.println(temp);
     if(temp=='V'){
      digitalWrite(led,1-digitalRead(led));    //change the LED statu if receiving the char "V".
    Serial.println("OK");    //reply OK to show that the char "V" has been received and the LED statu also has been changed 
     }
  }
}
