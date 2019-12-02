class FlyProjectileObserver extends EventObserver{
  
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
