class FiringObserver extends Observer{
  
  Player observable;
  Projectiles observer;
  
  FiringObserver(Player nobservable, Projectiles nobserver){
    observable = nobservable;
    observer = nobserver;
  }
  
  public void notifyPropertyChanged(){
    setPassingParameters(observable.getFirePos(), observable.getFireVel(), observable.getTeam());
  }
  
  private void setPassingParameters(PVector pos, PVector vel, int team){
    observer.addProjectile(pos, vel, team);
  }
  
  
}
