abstract class Fish {
  PVector position, desired, velocity;
  float scale, maxspeed, agility;
  color col;
  float randomizer = random(0, 1); // random value to make random behaviour different from oter instances of this class


  Fish(PVector position) {
    desired = new PVector(0, 0, 0);
    this.position = position;
    velocity = new PVector(random(-1, 1), 0, 0);
  }

  final void applyForce(PVector force, float weight) {
    //adds the force to desired after normalizing and multiplying by a weight to get a weighted average after doing so for every force
    if (force.mag()>0) {
      force.normalize();
    }
    desired.add(force.setMag(weight));
  }

   final PVector preferHorizontal() {
    //returns a force that steers the fish more in the horizontal direction it is going in, this looks better when looking at the aquarium
    PVector force = new PVector(0, 0, 0);
    if (velocity.x > 0) {
      force.set(1, 0, 0);
    }
    if (velocity.x<0) {
      force.set(-1, 0, 0);
    }
    return force;
  }

  final PVector avoidWalls(float range) {
    //returns a force that is pointing away from the wall the position of the fish is to close to
    PVector force = new PVector(0, 0, 0); 

    if (position.x < range) {
      force.add(1, 0, 0).setMag(range - position.x);
    }
    if (position.x > aquarium.w - range) {
      force.add(-1, 0, 0).setMag(position.x - (aquarium.w - range));
    }
    if (position.y < aquarium.water.h + range) {
      force.add(0, 1, 0).setMag((aquarium.water.h + range - position.y));
    }
    if (position.y > aquarium.sand.sandHeight - aquarium.sand.ROUGHNESS - range) {
      force.add(0, -1, 0).setMag(position.y - (aquarium.sand.sandHeight - aquarium.sand.ROUGHNESS - range));
    }
    if (position.z > aquarium.d - range) {
      force.add(0, 0, -1).setMag(position.z - (aquarium.d - range));
    }
    if (position.z < range) {
      force.add(0, 0, 1).setMag(range - position.z);
    }

    return force;
  }

  PVector ownWill(float strength) {
    //this method returns a force vector that is its velocity + a random noise vector to make it seem like it has its own will 
    PVector force = velocity.copy().add(new PVector(noise(frameCount/400.0 + randomizer * 3000) - 0.5, noise(frameCount/400.0 + randomizer * 1000) - 0.5, noise(frameCount/400.0 + randomizer * 2000) - 0.5).setMag(strength));
    return force;
  }

  final PVector seek(PVector location) {
    //this method returns a force vector that is pointed into the direction of the location in the arguments
    PVector force = PVector.sub(location, position).setMag(maxspeed);
    return force;
  }

  final PVector avoid(PVector location) {
    //this method returns a vector force that is pointed away from the location in the arguments
    PVector force = PVector.sub(position, location).setMag(maxspeed);
    return force;
  }

  PVector getFood(float range, float eatRange) {
    //this method returns a force vector that is pointed in the direction of the food that is within its range. When the food gets neer enough too the fish it eats the food and the food is deleted from the arrayList
    ArrayList<Fishfood> food = aquarium.fishfood;
    PVector force = new PVector(0, 0, 0);

    if (food.size() > 0) {
      Fishfood closest = food.get(0);
      float closestDist = food.get(0).position.dist(position);
      int closestIndex = 0;

      for (int i = 1; i < food.size(); i++) {
        Fishfood x = food.get(i);
        if (x.position.dist(position) < closestDist) {
          closest = x;
          closestDist = x.position.dist(position);
          closestIndex = i;
        }
      }

      if (closestDist < range) {
        force.add(seek(closest.position));
      }

      if (closestDist < eatRange) {
        aquarium.fishfood.remove(closestIndex);
      }
    }
    return force;
  }

  PVector avoidOther(float range, Fish[]... fish) {
    //method that keeps the fish from colliding, using varargs to allow for multiple fish array inputs

    float adjuster = 0.0001; //keeps /0 error from happening
    PVector force = new PVector(0, 0, 0);

    for (Fish[] allfish : fish) {
      for (Fish x : allfish) {
        if (x != this) {
          if (x.position.dist(position) < range) {
            force.add(avoid(x.position).setMag(1/(x.position.dist(position)+adjuster)));
          }
        }
      }
    }

    return force;
  }

  final PVector allign(float range, Fish[] fish) {
    //returns a vector force that is pointed in the direction of the average velocity of the fish in the array from the arguments within the range
    PVector force = new PVector(0, 0, 0);
    for (Fish x : fish) {
      if (position.dist(x.position) < range && x != this) {
        force.add(x.velocity.copy().normalize());
      }
    }

    return force;
  }

  final PVector cohere(Fish[] fish, float range) {
    //returns a vector force in the direction of the average location of the fish from the array in the arguments within the range
    PVector force = new PVector(0, 0, 0);
    for (Fish x : fish) {
      if (position.dist(x.position) < range && x != this) {
        force.add(PVector.sub(x.position, position));
      }
    }

    return force;
  }
}

final class Goldfish extends Fish {
  //subclass of fish for all the goldfish

  Goldfish(PVector position) {
    super(position);
    scale = random(10, 20);
    col = color(255, 180, 100);
    maxspeed = 1 + random(-0.5, 0.5);
    agility = 0.01;
  }


  void render() {
    //this methdod renders the fish according to its heading

    //the code above is the mathematics to convert spherical coordinates to cartesian coordinates
    float angleY = atan2(velocity.x, (velocity.z + 0.0001));
    float angleX = acos(velocity.y/(velocity.mag() + 0.0001));

    //position the fish in such a way that it is in its position and it is facing the way of it's velocity
    pushMatrix();
    translate(position.x, position.y, position.z);
    rotateY(+PI/2);
    rotateY(angleY);
    rotateZ(-PI/2);
    rotateZ(angleX);

    fill(col);
    float tailWiggle = 0.5 * (sin(frameCount/5.0 + randomizer) - 0.5); //adds some wiggle to the tail of the fish
    float finWiggle = 0.2 * (sin(frameCount/2.0 + randomizer * 10000) - 0.5);  //adds some wiggle to the fins of the fish

    scale(scale);
    scale(1, 0.9, 0.7); //change proportions of the fish

    //the code below describes the shape of the goldfish
    sphereDetail(8);
    sphere(1);
    beginShape();
    vertex(0, 0, 0);
    vertex(1.7, 1, tailWiggle);
    vertex(1.7, -1, tailWiggle);
    endShape();

    beginShape();
    vertex(-0.5, 0, 0.8);
    vertex( 0, finWiggle, 1.3);
    vertex(0.5, finWiggle, 1.3);
    vertex(0.5, 0, 0.8);
    endShape();

    beginShape();
    vertex(-0.5, 0, -0.8);
    vertex( 0, finWiggle, -1.3);
    vertex(0.5, finWiggle, -1.3);
    vertex(0.5, 0, -0.8);
    endShape();

    popMatrix();
  }

  void move() {
    //this method collects all the behaviours and is responsible for moving the fish according to its desires

    desired.set(0, 0, 0); //resets the desired vector for all the below "applyForce" methods to add to it
    applyForce(avoidWalls(100), 2);  //avoid walls with strenth 1
    applyForce(avoidOther(70, aquarium.goldfish), 1);  //avoid other goldfish from a range of 70 with strenth 1
    applyForce(getFood(700, 20), 0.2);  //try to get food from range 400 with strength 0.2
    applyForce(ownWill(0.2), 0.1);  //have some random own will with 0.2 power and 0.1 strenth

    PVector acceleration;
    acceleration = PVector.sub(desired.setMag(maxspeed), velocity).limit(agility); //acceleration is the difference between the desired velocity and the actual velocity limited by the agility of the fish
    velocity.add(acceleration);
    position.add(velocity);
  }
}

final class Tropicalfish extends Fish {
  //a subclass of fish describing all the tropicalfish

  color accent; 

  Tropicalfish(PVector location) {
    super(location);
    scale = random(6, 10);
    maxspeed = 3 + random(-1, 1);
    agility = 0.08;

    //the code below generates a random tropical color for the fish
    float colorrandomizer = int(random(0, 255));
    col = color(255-colorrandomizer, colorrandomizer, random(0, 100));
    accent = color(255 - colorrandomizer - 50, colorrandomizer + 50, random(0, 100));
  }

  void move() {
    //this method collects all the behaviours and is responsible for moving the fish according to its desires

    desired.set(0, 0, 0); //resets the desired vector for all the below "applyForce" methods to add to it
    applyForce(avoidWalls(100), 2);   //avoid the walls with strenth 1
    applyForce(avoidOther(40, aquarium.goldfish, aquarium.tropicalfish), 1);  //avoid both goldfish and tropicalfish with a range of 40 with srength 1
    applyForce(ownWill(0.2), 0.09); //have an own will with power 0.2 and strength 0.09
    applyForce(allign(200, aquarium.tropicalfish), 0.02); //allign with other goldfish around within a radius of 200 with strength 0.02
    applyForce(cohere(aquarium.tropicalfish, 50), 0.01);  //cohere with other fish from a range of 50 with strength 0.01;
    applyForce(preferHorizontal(), 0.008); //prefer to swim horizontally with strength 0.008

    PVector acceleration;
    acceleration = PVector.sub(desired.setMag(maxspeed), velocity).limit(agility); //acceleration is the difference between the desired velocity and the actual velocity limited by the agility of the fish
    velocity.add(acceleration);
    position.add(velocity);
  }

  void render() {
    //this methdod renders the fish according to its heading

    //the code above is the mathematics to convert spherical coordinates to cartesian coordinates
    float angleY = atan2(velocity.x, (velocity.z + 0.0001));
    float angleX = acos(velocity.y/(velocity.mag() + 0.0001));

    //position the fish in such a way that it is in its position and it is facing the way of it's velocity
    pushMatrix();
    translate(position.x, position.y, position.z);
    rotateY(+PI/2);
    rotateY(angleY);
    rotateZ(-PI/2);
    rotateZ(angleX);

    fill(col);
    float tailWiggle = (sin(frameCount/2.0 + randomizer) - 0.5); //adds some wiggle to the tail of the fish

    scale(scale);
    scale(1, 0.5, 0.5); //squash the fish a bit to make it look better;


    //the code below describes the shape of the tropicalfish
    sphereDetail(8);
    sphere(1);

    beginShape();
    vertex(0, -0.5, 0);
    bezierVertex(0, -0.5, 0, 2, -1.5, 0, 3.5, -1.2, tailWiggle);
    vertex(2.5, 0, tailWiggle);
    vertex(3.5, 1.2, tailWiggle);
    bezierVertex(3.5, 1.2, tailWiggle, 2, 1.5, 0, 0, 0.5, 0);
    vertex(0, 0.5, 0);

    fill(accent);
    vertex(0, 0, 0);
    bezierVertex(0, 0, 0, 4, -1, 0, 6, -0.5, tailWiggle/2);
    vertex(4, 0, tailWiggle/2);
    vertex(6, 0.5, tailWiggle/2);
    bezierVertex(6, 0.5, tailWiggle/2, 4, 1, 0, 0, 0, 0);
    vertex(0, 0, 0);
    endShape();
    popMatrix();
  }
}
