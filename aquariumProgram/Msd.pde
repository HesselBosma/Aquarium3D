class Msd {
  //this class is one of the points making up the water surface, they each calculate their own phisics accoring to their surroundings

  float m, c, k;
  float velocityY, accelerationY;
  PVector position;

  Msd(PVector position) {
    m = 0.3;
    c = 0.03;
    k = 0.04; 
    this.position = position;
  }

  void move(float neighborsY) {
    //mass spring damper physics according to the y coordinate of its neighbors in the arguments
    float x = neighborsY - position.y;
    float fs = x * k;
    float fd = velocityY * c;
    float fm = -fs - fd;
    accelerationY = fm/m;
    velocityY += accelerationY;
    position.y -= velocityY;
  }
}
