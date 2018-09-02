class Plant
  //class for the behaviour of the green plants in the left of the aquarium
{ 
  int triangleHeight, triangleWidth, size; 
  float speed, maxAngle, angleDistance, randomizer, scale;
  color col;
  PVector location;

  Plant(int size, float scale, PVector location)
  {
    this.location = location;
    col = color(random(50, 100), random(150, 250), random(50, 100));
    randomizer = random(0, 1);
    triangleHeight = 10; 
    triangleWidth = 10; 
    this.size = size;
    speed = 1/1000.0;
    maxAngle = radians(10);
    angleDistance = 30;
    this.scale = scale;
  }

  void render()
  {
    //this method renders the plant from the bottom up triangle by triangle using noise randomizations to move the plant
    fill(col);
    pushMatrix();
    translate(location.x, location.y, location.z);
    scale(scale);
    for (int n = 0; n < size; n++) {
      float angleY = map(noise(n * angleDistance, frameCount * speed + 1000 * randomizer), 0, 1, 0, 4* PI);
      float angleX = map(noise(n * angleDistance, frameCount * speed + 1000 * randomizer), 0, 1, -maxAngle, maxAngle);
      float angleZ= map(noise(n * angleDistance, frameCount * speed + 1000 * randomizer), 0, 1, -maxAngle, maxAngle);

      rotateX(angleX);
      rotateY(angleY);
      rotateZ(angleZ);
      triangle(0, 0, -0.5 * triangleWidth, -triangleHeight, 0.5 * triangleWidth, -triangleHeight); 
      translate(0, -triangleHeight, 0);
    }
    popMatrix();
  }
}
