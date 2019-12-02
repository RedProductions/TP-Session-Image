abstract class Particle extends GObject{
  
  float lifeTime;
  float maxLifeTime;
  
  boolean alive;
  
  abstract void show(ViewPort view);
  
  boolean isAlive(){return alive;}
  void setPos(PVector npos){pos = npos.copy();}
  
  void phys(){
    
    //acc.add(GRAVITY);
    vel.add(acc);
    vel.mult(0.98);
    
    pos.add(vel);
    
    
    acc.mult(0);
    
  }
  
  void setMega(){
    size.mult(2);
  }
  
  void timeGestion(float deltaTime){
    
    lifeTime += deltaTime;
    
    if(lifeTime >= maxLifeTime){
      alive = false;
    }
    
  }
  
}
