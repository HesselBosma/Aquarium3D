class Hud {
  //class containing all the hud elements

  FeedingBox feedingBox; 

  Hud(Aquarium aquarium) {
    feedingBox = new FeedingBox(aquarium.w, aquarium.d, 0.2);
  }

  void render() {
    camera();  //resets the camera to get 2d hud elements
    hint(DISABLE_DEPTH_TEST);  //depthtest has to be turned off to be able ot overlay 2d hud
    noLights();
    feedingBox.render();
    fill(0);
    text(frameRate, 10, 20); //fps counter
    hint(ENABLE_DEPTH_TEST);
  }
}
