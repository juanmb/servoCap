#include <SerialCommand.h>
#include <Servo.h>

#define VERSION "1.0"
#define BAUDRATE 38400
#define LIGHT_PIN LED_BUILTIN

#define SERVO1_PIN 9
#define SERVO1_CLOSED 0
#define SERVO1_OPEN 120

#define SERVO2_PIN 10
#define SERVO2_CLOSED 120
#define SERVO2_OPEN 20

Servo servo1;
Servo servo2;
SerialCommand sCmd;


void getVersion()
{
    Serial.println("*V"VERSION);
}

void getStatus()
{
    char motorSt='0', lightSt, coverSt;

    lightSt = digitalRead(LIGHT_PIN);

    int pos = servo1.read();
    if (pos ==  SERVO1_OPEN)
        coverSt = '1';
    else if (pos ==  SERVO1_CLOSED)
        coverSt = '2';
    else
        coverSt = '0';

    Serial.print("*S");
    Serial.print(motorSt);
    Serial.print(lightSt);
    Serial.println(coverSt);
}

void ForceOpen()
{
    servo1.write(SERVO1_OPEN);
    servo2.write(SERVO2_OPEN);
    Serial.println("*o000");
}

void Open()
{
    servo1.write(SERVO1_OPEN);
    servo2.write(SERVO2_OPEN);
    Serial.println("*o000");
}

void ForceClose()
{
    servo1.write(SERVO1_CLOSED);
    servo2.write(SERVO2_CLOSED);
    Serial.println("*c000");
}

void Close()
{
    servo1.write(SERVO1_CLOSED);
    servo2.write(SERVO2_CLOSED);
    Serial.println("*C000");
}

void Abort()
{
    Serial.println("*A000");
}

void enableLightbox()
{
    digitalWrite(LIGHT_PIN, HIGH);
    Serial.println("*L000");
}

void disableLightbox()
{
    digitalWrite(LIGHT_PIN, LOW);
    Serial.println("*L000");
}

void getBrightness()
{
    Serial.println("*J000");
}

void setBrightness()
{
    Serial.println("*B000");
}


void setup()
{
    servo1.attach(SERVO1_PIN);
    servo1.write(SERVO1_CLOSED);

    servo2.attach(SERVO2_PIN);
    servo2.write(SERVO2_CLOSED);

    // Map serial commands to functions
    sCmd.addCommand(">V000", getVersion);        // >V000\r\n
    sCmd.addCommand(">S000", getStatus);         // >S000\r\n
    sCmd.addCommand(">o000", ForceOpen);         // >o000\r\n
    sCmd.addCommand(">O000", Open);              // >O000\r\n
    sCmd.addCommand(">c000", ForceClose);        // >c000\r\n
    sCmd.addCommand(">C000", Close);             // >C000\r\n
    sCmd.addCommand(">A000", Abort);             // >A000\r\n
    sCmd.addCommand(">L000", enableLightbox);    // >L000\r\n
    sCmd.addCommand(">D000", disableLightbox);   // >D000\r\n
    sCmd.addCommand(">J000", getBrightness);     // >J000\r\n
    sCmd.addCommand(">B000", setBrightness);     // >BXXX\r\n

    Serial.begin(BAUDRATE);
}

void loop()
{
    sCmd.readSerial();
}
