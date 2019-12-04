///
///Shell of an active physic object
///
abstract class GObject{
  
  PVector pos;
  PVector size;
  
  PVector vel;
  PVector acc;
  
  
  float mass;
  float density;
  
  float bounceRatio;
  
  
  abstract void update(float delta);
  
  
  abstract void show();
  
  
  
}
