class Camera {
  //this class is all about the position/movement of the eye/camera

  float angleX, angleY, upX, upY, upZ;
  PVector position, direction, center;
  float moveSpeed, pivotSpeed;

  Camera(PVector position, PVector direction, float moveSpeed, float pivotSpeed) {
    upX = upZ = 0.0;
    angleX = PI/4;
    angleY = 0;
    upY = 1.0;
    this.position = position;
    this.direction = direction;
    this.moveSpeed = moveSpeed;
    this.pivotSpeed = radians(pivotSpeed);
    update();
  }

  void update() {
    //this function does the math of changing the position of the camera and where it is pointing

    direction.set(sin(angleY) * sin(angleX), cos(angleX), cos(angleY) * sin(angleX));
    //direction is the vector pointing in the direction where the camera is pointing

    center = position.copy().add(direction);
    //center is the an arbitrary point on the line commming out of the camera, this is needed because the built in camera needs this

    camera(position.x, position.y, position.z, center.x, center.y, center.z, upX, upY, upZ);
  }


  //the functions below are used to change the position and heading of the camera
  void forwards() {
    position.add(direction.copy().setMag(moveSpeed));
  }

  void backwards() {
    position.sub(direction.copy().setMag(moveSpeed));
  }

  void left() {
    PVector left= new PVector(direction.z, 0, direction.x * -1);
    position.add(left.setMag(moveSpeed));
  }  

  void right() {
    PVector right = new PVector(direction.z * -1, 0, direction.x);
    position.add(right.setMag(moveSpeed));
  }

  void down() {
    position.y += moveSpeed;
  }

  void up() {
    position.y -= moveSpeed;
  }

  void tiltUp() {
    angleX += pivotSpeed;
  }

  void tiltDown() {
    angleX -= pivotSpeed;
  }

  void rotateLeft() {
    angleY += pivotSpeed;
  }

  void rotateRight() {
    angleY -= pivotSpeed;
  }
}
