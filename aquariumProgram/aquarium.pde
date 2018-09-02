class Aquarium {
  //this class is about the aquarium and everything in it

  PShape rock, rock2, ship, palmTree; 
  float w, h, d, pannelWidth, pedistolHeight;
  int bubbleFrequency = 5;
  PVector location;
  color glassColor, pedistolColor, tableColor, shipColor, treeColor, rockColor;

  Sand sand;
  Water water;

  //arraylist for the fishfood droped into the aquarium
  ArrayList<Fishfood> fishfood = new ArrayList<Fishfood>();

  //arraylist for the bubbles comming from the ship
  ArrayList<Bubble> bubbles = new ArrayList<Bubble>();

  //arrays of the fish
  Goldfish[] goldfish = new Goldfish[6];
  Tropicalfish[] tropicalfish = new Tropicalfish[30];

  //array of plants in the right of the aquarium
  Plant[] plants = new Plant[20];

  Aquarium(PVector location, float w, float h, float d, float pannelWidth) {
    this.location = location;
    this.w = w;
    this.h = h;
    this.d = d;
    this.pannelWidth = pannelWidth;
    pedistolHeight = h/8.0;

    //choosing all the colors;
    glassColor = color(50, 50, 100, 50);
    pedistolColor = color(30, 30, 40);
    tableColor = color(54, 38, 27);
    shipColor = color(182, 155, 76); 
    treeColor = color(77, 168, 59); 
    rockColor = color(65, 77, 90  );

    //using obj files to get complex shapes in 3d
    ship = loadShape("AmerWarship.obj"); 
    rock = loadShape("rocks.obj");
    rock2 = loadShape("Stone07.obj");
    palmTree = loadShape("palm1.obj");


    //picking spots for the obj shapes using pshape translate method
    rock.translate(100, -150, 100);
    ship.translate(20, 16, 100);
    palmTree.translate(-50, 80, 50);
    rock2.translate(-1000, -100, 300); 

    //intitializing all the objects in the aquarium
    sand = new Sand( w, d);
    water = new Water(w, d, -h + 120);
    for (int i = 0; i<goldfish.length; i++) {
      goldfish[i] = new Goldfish(new PVector(random(0, w), random(water.h, (sand.ROUGHNESS * -1 - sand.sandHeight)), random(0, d)));
    }
    for (int i = 0; i<tropicalfish.length; i++) {
      tropicalfish[i] = new Tropicalfish(new PVector(random(0, w), random(water.h, (sand.ROUGHNESS * -1 - sand.sandHeight)), random(0, d)));
    }
    float plantSpread = 100;
    for (int i =0; i<plants.length; i++) {
      plants[i] = new Plant(int(random(10, 20)), random(2, 3), new PVector(random(-plantSpread, plantSpread), 0, random(-plantSpread, plantSpread)));
    }
  }

  void move() {
    //this method makes everything in the aquarium move

    //generate bubble every 'bubblefrequency' frames
    if (frameCount % bubbleFrequency == 0) {
      bubbles.add(new Bubble(new PVector(random(950, 970), random(-200, -210), random(160, 170)), int(random(5, 10))));
    }

    //moves the bubble and removes them if necicary
    for (int i =0; i < bubbles.size(); i++) {
      bubbles.get(i).move(); 
      if (bubbles.get(i).surface) {
        bubbles.remove(i);
        i--;
      }
    }

    //moves the fishfood
    for (Fishfood x : fishfood) {
      x.move();
    }  

    //moves the fish
    for (Goldfish x : goldfish) {
      x.move();
    }  
    for (Tropicalfish x : tropicalfish) {
      x.move();
    }  

    //moves the water
    water.move();
    water.splash(fishfood);
    water.bubbles(bubbles);
  }  

  void render() {
    //renders everything in the aquarium

    //the code below renders the pannels of the aquarium temporarily disabling depthtest to make them transparent correctly
    fill(glassColor);
    strokeWeight(5); 
    hint(DISABLE_DEPTH_TEST); //makes sure transparency works correctly
    pushMatrix();
    translate(location.x, location.y, location.z);
    pushMatrix();
    translate(0, 0, -d);
    box(w, h, pannelWidth);
    popMatrix();
    box(w, h, pannelWidth);
    pushMatrix();
    translate(-w/2 + pannelWidth/2, 0, -d/2);
    rotateY(radians(90));
    box(d, h, pannelWidth);
    popMatrix();
    pushMatrix();
    translate(w/2 - pannelWidth/2, 0, -d/2);
    rotateY(radians(90));
    box(d, h, pannelWidth);
    popMatrix();

    hint(ENABLE_DEPTH_TEST); //makes sure transparency works correctly

    //renders the pedistol    
    translate(0, h/2 + pedistolHeight/2, -d/2);
    fill(pedistolColor);
    box(w + pannelWidth, pedistolHeight, d + pannelWidth);
    translate(0, 80, 0); 
    box(w*1.05, h/10, d*1.3);
    translate(0, 140, 0);

    //renders the table below the aquarium
    fill(tableColor); 
    box(w * 2, h/4, d*2.5); 
    translate(0, 300, 0);
    box(w * 2, h, d*2); 
    popMatrix();
    translate(-w/2, h/2, -d);

    //renders rock1
    pushMatrix(); 
    scale(1.5); 
    shape(rock); 
    popMatrix();

    //renders the ship
    pushMatrix();
    rotateX(PI/20); 
    rotateY(PI/2);
    rotateZ(PI); 
    scale(8); 
    ship.setFill(shipColor);
    shape(ship);
    popMatrix();


    //renders rock 2
    pushMatrix(); 
    rotateY(degrees(-30));
    scale(1.5); 
    rock2.setFill(rockColor); 
    shape(rock2); 
    popMatrix();

    //renders the palm trees
    pushMatrix(); 
    rotateZ(PI);
    scale(3); 
    palmTree.setFill(treeColor);
    shape(palmTree); 
    popMatrix();

    //renders the sand
    pushMatrix();
    translate(10, 0, 1);
    sand.render();
    popMatrix();

    //renders the plants
    pushMatrix();
    translate(1700, -100, 200);
    for (Plant x : plants) {
      x.render();
    } 
    popMatrix();

    //renders the fishfood
    for (Fishfood x : fishfood) {
      x.render();
    } 

    //renders the goldfish
    for (int i = 0; i<goldfish.length; i++) {
      goldfish[i].render();
    }

    //renders the tropicalfish
    for (int i = 0; i<tropicalfish.length; i++) {
      tropicalfish[i].render();
    }

    //renders the bubbles
    for (Bubble x : bubbles) {
      x.render();
    }
    water.render();
  }
}
