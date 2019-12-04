///
///Observer to make the Player fire Projectiles
///
class FiringObserver extends Observer{
  
  Player observable;
  Projectiles observer;
  
  FiringObserver(Player nobservable, Projectiles nobserver){
    observable = nobservable;
    observer = nobserver;
  }
  
  ///
  ///Notifies the observer
  ///
  public void notifyPropertyChanged(){
    setPassingParameters(observable.getFirePos(), observable.getFireVel(), observable.getTeam());
  }
  
  ///
  ///Creates a projectile for the observer
  ///
  private void setPassingParameters(PVector pos, PVector vel, int team){
    observer.addProjectile(pos, vel, team);
  }
  
  
}
