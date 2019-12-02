abstract class Observable{
  
  private boolean notification;
  
  protected void notifyObs(){notification = true;}
  
  public boolean isNotified(){return notification;}
  public void confirmNotification(){notification = false;}
  
}
