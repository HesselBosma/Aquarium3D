//This class controls the lighting present in the scene 
class Lighting
{ 
  float r,g,b;

  //RGB colors can be selected when calling the function 
  Lighting(float r, float g, float b)
  {
    this.r = r;
    this.g = g;
    this.b = b;
  }
  //Ability to choose if you want the scene to have a directional light or an ambient light
  void directional()
  {
    noStroke();
    directionalLight(r, g, b, -2, 5, 5);
    directionalLight(r, g, b, 2, 6, -5);
  }
}
