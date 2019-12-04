///
///Observable that notifies when and what sound should be played
///
class SoundObservable extends Observable{
  
  private Sounds sound;
  
  ///
  ///Sets the sound type to be played
  ///
  public void setSound(Sounds nsound){sound = nsound;}
  public Sounds getSound(){return sound;}
  
}
