///
///Shell of a physics active particle
///
abstract class Particle extends GObject{
  
  float lifeTime;
  float maxLifeTime;
  
  boolean alive;
  
  ///
  ///Render method declaration
  ///
  abstract void show(ViewPort view);
  
  boolean isAlive(){return alive;}
  void setPos(PVector npos){pos = npos.copy();}
  
  ///
  ///Calculates the physics
  ///
  void phys(){
    
    //acc.add(GRAVITY);
    vel.add(acc);
    vel.mult(0.98);
    
    pos.add(vel);
    
    
    acc.mult(0);
    
  }
  
  ///
  ///Makes the particle twice as big
  ///
  void setMega(){
    size.mult(2);
  }
  
  ///
  ///Calculates its life time
  ///
  void timeGestion(float deltaTime){
    
    lifeTime += deltaTime;
    
    if(lifeTime >= maxLifeTime){
      alive = false;
    }
    
  }
  
}
