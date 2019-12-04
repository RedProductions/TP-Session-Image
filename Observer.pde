///
///Shell of an observing entity observing Observable
///
abstract class Observer{
  
  Observer(){
    obs = new ArrayList<Observable>();
  }
  
  protected ArrayList<Observable> obs;
  
  ///
  ///Adds an observable entity to its observing list
  ///
  public void addObservable(Observable nObs){
    if(nObs != null && obs != null){
      obs.add(nObs);
    }
  }
  
  ///
  ///Tells if an observable entity has a notification
  ///
  protected boolean isNotified(){
   if(obs != null){
     for(Observable part : obs){
       if(part.isNotified()){
         return true;
       }
     }
   }
   
   return false;
  }
  
}

///
///Observer that can pass the index of the Observable 
///
abstract class EventObserver extends Observer{
  
  abstract int getNotifiedIndex();
  
}
