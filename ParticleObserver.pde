class ParticleObserver extends EventObserver{
  
  int getNotifiedIndex(){return 0;}
  
  public void findType(ParticleType type){
    
    for(Observable part : obs){
      
      if(((ParticleObservable)part).getParams() != null){
        if(((ParticleObservable)part).getParams().type == ParticleType.STAR){
          if(part.isNotified()){
            println("NOTIFIED STAR");
          }else {
            println("SILENT STAR");
          }
        }
      }
      
    }
    
  }
  
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
