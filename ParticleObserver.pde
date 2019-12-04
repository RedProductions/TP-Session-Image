///
///Observer that reads the notifications of the Particle Observable to spawn a Particle when needed
///
class ParticleObserver extends EventObserver{
  
  int getNotifiedIndex(){return 0;}
  
  ///
  ///Returns the passing the first found parameters of a spawning particle
  ///
  public ParticleParams getParams(){
    
    boolean foundPos = false;
    ParticleParams params = null;
    
    for(Observable part : obs){
      
      if(!foundPos){
        
        if(part.isNotified()){
          params = ((ParticleObservable)part).getParams();
          part.confirmNotification();
          foundPos = true;
        }
        
      }
      
    }
    
    return params;
    
  }
  
  ///
  ///Tells if particles must be spawned
  ///
  boolean hasNotification(){
    
    boolean found = false;
    
    for(Observable part : obs){
      if(part.isNotified()){
        found = true;
      }
    }
    
    return found;
    
  }
  
  
}
