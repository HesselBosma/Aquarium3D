/*
    ---Aquarium---
 End assignment algorithms for Creative Technology at the University of Twente
 
 By: Rezfan Pawirotaroeno & Hessel Bosma
 Date: june-2018
 */

Camera camera;
Aquarium aquarium;
Lighting  lighting; 
Hud hud;

boolean keyW, keyS, keyA, keyD, keyShift, keyCTRL, up, down, left, right;
float gravityconstant = 0.15;

void setup() {
  fullScreen(P3D);
  frameRate(60);

  camera = new Camera(new PVector(0, 0, -1000), new PVector(0, 0, 1), 20, 1);
  aquarium = new Aquarium(new PVector(0, 0, 0), 2000, 800, 400, 5);
  lighting = new Lighting(150, 150, 150);
  hud = new Hud(aquarium);
}

void draw() {
  camera.update();
  background(255);
  lighting.directional(); 
  aquarium.render();
  aquarium.move();
  getInput();
  hud.render();
}

void mousePressed() {
  hud.feedingBox.click();
}

void keyPressed() {
  //the code below is for getting and storing the keyboard input to be used by different methods called at the bottom of this class

  if (key == 'w') {
    keyW = true;
  }
  if (key == 's') {
    keyS = true;
  }
  if (key == 'a') {
    keyA = true;
  }
  if (key == 'd') {
    keyD = true;
  }
  if (keyCode == SHIFT) {
    keyShift = true;
  }
  if (keyCode == CONTROL) {
    keyCTRL = true;
  }
  if (keyCode == UP) {
    up = true;
  }
  if (keyCode == DOWN) {
    down = true;
  }
  if (keyCode == LEFT) {
    left = true;
  }
  if (keyCode == RIGHT) {
    right = true;
  }
}

void keyReleased() {
  if (key == 'w') {
    keyW = false;
  }
  if (key == 's') {
    keyS = false;
  }
  if (key == 'a') {
    keyA = false;
  }
  if (key == 'd') {
    keyD = false;
  }
  if (keyCode == SHIFT) {
    keyShift = false;
  }
  if (keyCode == CONTROL) {
    keyCTRL = false;
  }
  if (keyCode == UP) {
    up = false;
  }
  if (keyCode == DOWN) {
    down = false;
  }
  if (keyCode == LEFT) {
    left = false;
  }
  if (keyCode == RIGHT) {
    right = false;
  }
}

void getInput() {
  if (keyW) {
    camera.forwards();
  }
  if (keyS) {
    camera.backwards();
  }
  if (keyA) {
    camera.left();
  }
  if (keyD) {
    camera.right();
  }
  if (keyShift) {
    camera.up();
  }
  if (keyCTRL) {
    camera.down();
  }
  if (up) {
    camera.tiltUp();
  }
  if (down) {
    camera.tiltDown();
  }
  if (left) {
    camera.rotateLeft();
  }
  if (right) {
    camera.rotateRight();
  }
}
