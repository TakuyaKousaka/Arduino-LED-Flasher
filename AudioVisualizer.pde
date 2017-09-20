import ddf.minim.*;
import processing.serial.*;
import cc.arduino.*;

Minim minim;
AudioInput in ;
Arduino arduino;

int scaledAudioInput;

int redPin = 11;
int greenPin = 10;
int bluePin = 9;


float sum;
float averageAudioInput;

void setup() {
 size(260, 50, P3D);

 arduino = new Arduino(this, Arduino.list()[0]);
 arduino.pinMode(redPin, Arduino.OUTPUT);
 arduino.pinMode(greenPin, Arduino.OUTPUT);
 arduino.pinMode(bluePin, Arduino.OUTPUT);
 minim = new Minim(this);

 // get a line in from Minim, default bit depth is 16 
 in = minim.getLineIn(Minim.MONO, 512);
}

void draw() {
 background(255);
 stroke(0);

 sum = 0;

 //Draw the waveforms 
 for (int i = 0; i < in .bufferSize() - 1; i++) {
  line(i, height / 2 + in .left.get(i) * height / 2, i + 1, height / 2 + in .right.get(i + 1) * height / 2);
  sum = sum + abs( in .right.get(i));
 }

 averageAudioInput = sum / in .bufferSize();
 scaledAudioInput = int(constrain(averageAudioInput * 2555, 0, 255));

 //Debug
 //print(scaledAudioInput);

 //LED Dance
 if (scaledAudioInput > 0) {
  setColor(scaledAudioInput, scaledAudioInput, scaledAudioInput);
 } else {
  setColor(255, 160, 255);
 }
}

//Apply RGB Values
void setColor(int red, int green, int blue) {
 arduino.analogWrite(redPin, 255 - red);
 arduino.analogWrite(greenPin, 255 - green);
 arduino.analogWrite(bluePin, 255 - blue);
}

void stop() {
 // always close Minim audio classes when you are done with them 
 in .close();
 minim.stop();
 super.stop();
}