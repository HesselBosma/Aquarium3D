class FeedingBox {
  //this is the class for the blue box at the bottom right of the screen for feeding the fish

  float aquariumWidth, aquariumDepth, scale, borderWidth;
  PVector location;
  boolean hover;

  FeedingBox(float aquariumWidth, float aquariumDepth, float scale) {
    this.aquariumWidth = aquariumWidth;
    this.aquariumDepth = aquariumDepth;
    this.scale = scale;
    location = new PVector(width - aquariumWidth * scale - 10, height - aquariumDepth * scale - 10);
    borderWidth = 10;
  }

  void render() {
    //this method renders the feedingbox

    fill(10, 100, 250, 100);
    stroke(0);
    strokeWeight(2);
    rect(location.x, location.y, scale * aquariumWidth, scale * aquariumDepth); 

    //feedingbox is a scaled version of the topview of the aquarium so the coordinates of the mouse are easily mapped to a coordinate in 3d space
    if (mouseX > location.x + borderWidth && mouseX < location.x + scale * aquariumWidth - borderWidth && mouseY > location.y + borderWidth && mouseY < location.y + aquariumDepth * scale - borderWidth) {
      hover = true;
      fill(200, 150, 100);
      ellipse(mouseX, mouseY, 10, 10);
    } else {
      hover = false;
    }
  }

  void click() {
    //when the mouse is clicked a new fishfood is added to the arrayList in the Aquarium class and droped into the aquarium, according to the position of the mouse inside the box
    if (hover) {
      aquarium.fishfood.add(new Fishfood(new PVector(aquariumWidth - (mouseX - location.x) / scale, -1000, aquariumDepth - (mouseY - location.y) / scale)));
    }
  }
}
