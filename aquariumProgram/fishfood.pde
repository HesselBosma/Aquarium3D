class Fishfood {
  //this class is for the fishfood that is dropped into the water

  PVector position, velocity, acceleration;
  float radius, drag, mass, swing, randomizer;

  Fishfood(PVector position) {
    radius = 5;
    this.position = position;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    drag = 0;
    mass = 1;
    swing = 3;
    randomizer = random(0, 2000);
  }

  void render() {
    //this method renders the fishfood

    pushMatrix();
    translate(position.x, position.y, position.z);
    sphere(radius); 
    popMatrix();
  }

  void move() {
    //moves the fishfood according to simple phisics and a random swinging motion made with the noise function;

    acceleration.set(0, gravityconstant, 0);
    acceleration.add(velocity.copy().mult(-1 * drag));
    velocity.add(acceleration);
    position.add(velocity).add(new PVector(swing * drag * (noise(frameCount/10 + 2000 + randomizer)-0.5), 0, swing * drag * (noise(frameCount/10 + randomizer)-0.5)));
  }
}
