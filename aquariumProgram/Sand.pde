class Sand {
  //this class is about the sand floor at the bottom of the aquarium

  float sandWidth, sandHeight, sandDepth;
  float RESOLUTION, ROUGHNESS, SMOOTHNESS, SCALE;
  float [][] grid;
  color sandColor;

  Sand(float sandWidth, float sandDepth) {
    this.sandWidth = sandWidth;
    this.sandDepth = sandDepth;

    sandHeight= 2;

    ROUGHNESS = 300;
    SMOOTHNESS = 15;
    RESOLUTION = 0.02;
    SCALE = 0.99;

    //the following code initializes the grid array to make the surface of the sand floor according to the built in noise function
    grid = new float[int(sandDepth * RESOLUTION) + 1][int(sandWidth * RESOLUTION) + 1];
    println(grid[0].length, grid.length);
    for (int z = 0; z < grid.length; z++) {
      for (int x = 0; x < grid[0].length; x++) {
        grid[z][x] = -sandHeight - ROUGHNESS * noise(z / SMOOTHNESS, x/SMOOTHNESS);
      }
    }

    sandColor = color(209, 203, 144);
  }

  void render() {
    //this method displays the sand


    fill(sandColor);

    //the loops below render the top surface of the sand floor
    for (int z = 0; z < grid.length-1; z++) {
      for (int x = 0; x < grid[0].length-1; x++) {
        beginShape();
        vertex(x / RESOLUTION * SCALE, grid[z][x] * SCALE, z / RESOLUTION * SCALE);
        vertex((x + 1) / RESOLUTION * SCALE, grid[z][x+1] *SCALE, z / RESOLUTION *SCALE);
        vertex((x+1) / RESOLUTION * SCALE, grid[z + 1][x + 1] * SCALE, (z+1) / RESOLUTION * SCALE);
        vertex(x / RESOLUTION * SCALE, grid[z + 1][x] * SCALE, (z + 1) / RESOLUTION * SCALE);
        endShape();
      }
    }

    //the part bellow fills in the sides of the sand floor
    beginShape();
    vertex(0, 0, 0);
    for (int z = 0; z < grid.length; z++) {
      vertex(0 * SCALE, grid[z][0] * SCALE, z / RESOLUTION * SCALE);
    }
    vertex(0, 0, sandDepth * SCALE);
    endShape();

    beginShape();
    vertex(sandWidth * SCALE, 0, 0);
    for (int z = 0; z < grid.length; z++) {
      vertex(sandWidth * SCALE, grid[z][grid[0].length-1] * SCALE, z / RESOLUTION * SCALE);
    }
    vertex(sandWidth * SCALE, 0, sandDepth * SCALE);
    endShape();

    beginShape();
    vertex(0, 0, sandDepth * SCALE);
    for (int x = 0; x < grid[0].length; x++) {
      vertex(x / RESOLUTION * SCALE, grid[grid.length - 1][x] * SCALE, sandDepth * SCALE);
    }
    vertex(sandWidth * SCALE, 0, sandDepth * SCALE);
    endShape();

    beginShape();
    vertex(0, 0, 0);
    for (int x = 0; x < grid[0].length; x++) {
      vertex(x / RESOLUTION * SCALE, grid[0][x] * SCALE, 0);
    }
    vertex(sandWidth * SCALE, 0, 0);
    endShape();
  }
}
