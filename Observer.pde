abstract class Observer{
  
  protected ArrayList<Observable> obs;
  public void addObservable(Observable nObs){
    if(nObs != null && obs != null){
      obs.add(nObs);
    }
  }
  
}


abstract class EventObserver extends Observer{
  
  EventObserver(){
    obs = new ArrayList<Observable>();
  }
  
  abstract int getNotifiedIndex();
  
}
