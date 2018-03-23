#include <SerialCommand.h>
#include <Servo.h>

#define VERSION "1.0"
#define BAUDRATE 38400
#define LIGHT_PIN LED_BUILTIN

#define BUTTON_PIN 2

#define SERVO1_PIN 9
#define SERVO1_CLOSED 0
#define SERVO1_OPEN 120

#define SERVO2_PIN 10
#define SERVO2_CLOSED 120
#define SERVO2_OPEN 12

enum {ST_CLOSED, ST_OPEN};

Servo servo1;
Servo servo2;
SerialCommand sCmd;
int state = ST_CLOSED;


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

void openCaps()
{
    servo1.write(SERVO1_OPEN);
    servo2.write(SERVO2_OPEN);
    state = ST_OPEN;
}

void closeCaps()
{
    servo1.write(SERVO1_CLOSED);
    servo2.write(SERVO2_CLOSED);
    state = ST_CLOSED;
}

void ForceOpen()
{
    openCaps();
    Serial.println("*o000");
}

void Open()
{
    openCaps();
    Serial.println("*O000");
}

void ForceClose()
{
    closeCaps();
    Serial.println("*c000");
}

void Close()
{
    closeCaps();
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
    pinMode(BUTTON_PIN, INPUT);
    digitalWrite(BUTTON_PIN, HIGH); // enable pull-up resistor

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
    static int prev_button = 0;
    static long time = 0;
    sCmd.readSerial();

    if (millis() - time > 50) {
        int button = !digitalRead(BUTTON_PIN);

        if (button && (button != prev_button)) {
            switch(state) {
                case ST_CLOSED:
                    openCaps();
                    break;
                case ST_OPEN:
                    closeCaps();
                    break;
            };
        }

        prev_button = button;
        time = millis();
    }
}
