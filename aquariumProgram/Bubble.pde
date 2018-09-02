// Class bubble contains all the characteristics (movement, acceleration, position) of the individual bubbles present in the aquarium 
class Bubble 
{  
  PVector position, velocity, acceleration;  
  int bubbleSize; 
  float mass;
  boolean surface;

  Bubble(PVector position, int bubbleSize) 
  {
    surface = false;
    this.bubbleSize = bubbleSize;
    this.position = position;  
    velocity = new PVector(0, 0, 0);
    acceleration = new PVector(random(-0.02, 0.02), random (-0.3, -0.1), random(-0.02, 0.02));
    mass = 1;
  }

  void move()   //basic bubble physics and constraints
  {
    position.add(velocity); 
    velocity.add(acceleration);
    velocity.limit(5);
  }

  void render() { 
    //renders the bubble on its location using the sphere method
    noStroke(); 
    pushMatrix(); 
    translate(position.x, position.y, position.z);
    fill(150, 150, 255, 50);
    sphere(bubbleSize);
    popMatrix();
  }
}
