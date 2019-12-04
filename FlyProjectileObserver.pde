///
///Observer to recieve a notification that an Enemy has been hit by a Projectile
///
class FlyProjectileObserver extends EventObserver{
  
  ///
  ///Get the index of the hit fly
  ///
  int getNotifiedIndex(){
    
    int index = -1;
    
    for(Observable part : obs){
      
      if(part.isNotified() && index == -1){
        index = ((FlyProjectileObservable)part).getIndex();
        part.confirmNotification();
      }
      
    }
    
    return index;
    
  }
  
  
}
