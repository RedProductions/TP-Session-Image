///
///Shell of an observable entity being observed by an Observer
///
abstract class Observable{
  
  private boolean notification;
  
  ///
  ///Notified its observer
  ///
  protected void notifyObs(){notification = true;}
  
  ///
  ///Tells if the observable has a notification
  ///
  public boolean isNotified(){return notification;}
  
  ///
  ///Removes the notification when it has been acknowledged
  ///
  public void confirmNotification(){notification = false;}
  
}
