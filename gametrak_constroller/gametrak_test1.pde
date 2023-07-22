import processing.serial.*;

Serial serial;
String inputString = "";
boolean isDataReceived = false;

import processing.core.*;

PShape cube1, cube2;
float cubeSize = 50;
PVector cube1Position, cube2Position;


void setup() {
  size(768, 768,P3D);
  println(Serial.list());
  serial = new Serial(this, Serial.list()[1], 115200); // Change the index if necessary

  // Initialize cube positions
  cube1Position = new PVector(width/2, height/2, 0);
  cube2Position = new PVector(width/2, height/2, 0);

  // Create cubes
  cube1 = createCube(cubeSize);
  cube2 = createCube(cubeSize);
}

void draw() {

  if (isDataReceived) {
    background(127);
    fill(255, 255, 255);
    translate(width/2,height/2);
    String[] data = inputString.split(",");

    if (data.length == 9 && data[0].equals("I") && data[7].equals("S")) {
      int wire1Value = Integer.parseInt(data[1]);
      int wire2Value = Integer.parseInt(data[2]);
      int joyRYValue = Integer.parseInt(data[5]);
      int joyRXValue = Integer.parseInt(data[6]);
      int joyLYValue = Integer.parseInt(data[3]);
      int joyLXValue = Integer.parseInt(data[4]);

      int switch1Value = 0;
      try {
        switch1Value = Integer.parseInt(data[8]);
      }
      catch (NumberFormatException nfe) {
        // Handle the condition when str is not a number.
      }


      // Display the values on the screen
      text("Wire 1: " + wire1Value, 50, 50);
      text("Wire 2: " + wire2Value, 50, 70);
      text("Joy R Y: " + joyRYValue, 50, 90);
      text("Joy R X: " + joyRXValue, 50, 110);
      text("Joy L Y: " + joyLYValue, 50, 130);
      text("Joy L X: " + joyLXValue, 50, 150);
      text("Switch 1: " + switch1Value, 50, 170);


      // Update cube positions based on joystick values
      cube1Position.y = map(wire1Value, 0, 1023, 0, height);
      cube1Position.z = map(joyRYValue, 0, 1023, -height/2, height/2);
      cube1Position.x = map(joyRXValue, 0, 1023, -width/2, width/2);

      cube2Position.y = map(wire2Value, 0, 1023, 0, height);
      cube2Position.z = map(joyLYValue, 0, 1023, -height/2, height/2);
      cube2Position.x = map(joyLXValue, 0, 1023, -width/2, width/2);

      // Draw cubes
      drawCube(cube1, cube1Position);
      drawCube(cube2, cube2Position);
    } else
    {
      println("error");
    }


    inputString = "";
    isDataReceived = false;
  }
}

void serialEvent(Serial port) {
  while (port.available() > 0) {
    char incomingChar = (char)port.read();

    if (incomingChar != '-' && incomingChar != '\n') {
      inputString += incomingChar;
      //println(inputString);
    } else {
      isDataReceived = true;
      port.clear();
    }
  }
}
PShape createCube(float size) {
  PShape cube = createShape(BOX, size, size, size);
  cube.setFill(color(255, 0, 0));
  return cube;
}

void drawCube(PShape cube, PVector position) {
  pushMatrix();
  translate(position.x, position.y, position.z);
  shape(cube);
  popMatrix();
}
