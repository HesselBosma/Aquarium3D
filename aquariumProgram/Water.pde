class Water {
  //this class handles the water inside the aquarium

  float w, d, h;
  Msd[][] points;
  float RESOLUTION = 0.03;

  Water(float w, float d, float h) {
    this.w = w;
    this.d = d;
    this.h = h;

    //making a grid of mass spring damper points
    points = new Msd[int(d * RESOLUTION + 1)][int(w * RESOLUTION + 1)];

    //intitializing the poinits array
    for (int z = 0; z < points.length; z++) {
      for (int x = 0; x < points[0].length; x++) {
        points[z][x] = new Msd(new PVector(x / RESOLUTION, h, z / RESOLUTION));
      }
    }
  }

  void move() {
    //calls the mass spring damper points to move and gives them their neighbors y position as argument
    for (int z = 0; z < points.length; z++) {
      for (int x = 0; x < points[0].length; x++) {
        float neighborsY = 0;

        if (z != 0) {
          neighborsY += points[z - 1][x].position.y;
        } else {
          neighborsY += h;
        }

        if (x != points[0].length -1) {
          neighborsY += points[z][x+1].position.y;
        } else {
          neighborsY += h;
        }

        if (z != points.length -1) {
          neighborsY += points[z + 1][x].position.y;
        } else {
          neighborsY += h;
        }

        if (x!=0) {
          neighborsY += points[z][x-1].position.y;
        } else {
          neighborsY += h;
        }

        neighborsY /= 4;

        points[z][x].move(neighborsY);
      }
    }
  }

  void render() {
    fill(50, 100, 250, 150);

    //the code below renders the top surface according to the height of each msd point.
    for (int z = 0; z < points.length -1; z++) {
      for (int x = 0; x < points[0].length -1; x++) {
        beginShape();
        vertex(points[z][x].position.x, points[z][x].position.y, points[z][x].position.z);
        vertex(points[z][x + 1].position.x, points[z][x + 1].position.y, points[z][x + 1].position.z);
        vertex(points[z + 1][x + 1].position.x, points[z + 1][x + 1].position.y, points[z + 1][x + 1].position.z);
        vertex(points[z + 1][x].position.x, points[z + 1][x].position.y, points[z + 1][x].position.z);
        endShape();
      }
    }

    //the code below renders the sides of the water;
    beginShape();
    vertex(0, 0, 0);
    for (int z = 0; z < points.length; z++) {
      vertex(0, points[z][0].position.y, z / RESOLUTION);
    }
    vertex(0, 0, d);
    endShape();

    beginShape();
    vertex(w, 0, 0);
    for (int z = 0; z < points.length; z++) {
      vertex(w, points[z][points[0].length-1].position.y, z / RESOLUTION);
    }
    vertex(w, 0, d);
    endShape();

    beginShape();
    vertex(0, 0, d);
    for (int x = 0; x < points[0].length; x++) {
      vertex(x / RESOLUTION, points[points.length - 1][x].position.y, d);
    }
    vertex(w, 0, d);
    endShape();

    beginShape();
    vertex(0, 0, 0);
    for (int x = 0; x < points[0].length; x++) {
      vertex(x / RESOLUTION, points[0][x].position.y, 0);
    }
    vertex(w, 0, 0);
    endShape();
  }

  void splash(ArrayList<Fishfood> fishfood) {

    for (Fishfood chunk : fishfood) {
      for (int z = 0; z< points.length; z++) {
        for (int x = 0; x < points[0].length; x++) {
          if (chunk.position.dist(points[z][x].position) <= 20) {

            points[z][x].velocityY -= chunk.mass / (chunk.mass + points[z][x].m) * chunk.velocity.y * 2;
          }
          if (chunk.position.y > points[z][x].position.y) {
            chunk.drag = 0.4;
          }
        }
      }
    }
  }

void bubbles(ArrayList<Bubble> bubbles) {
  for (Bubble bubble : bubbles) {
    for (int z = 0; z< points.length; z++) {
      for (int x = 0; x < points[0].length; x++) {
        if (bubble.position.dist(points[z][x].position) <= 20) {
          points[z][x].velocityY += bubble.mass / (bubble.mass + points[z][x].m) * bubble.velocity.y;
        }
        if (bubble.position.y < points[z][x].position.y) {
          bubble.surface = true;
        }
      }
    }
  }
}
}
