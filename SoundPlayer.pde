import ddf.minim.*;

///
///Types of sounds
///
enum Sounds{
  
  PROJECTILE_IMPACT,                                    //PROJECTILES
  FLY_DIE, BIG_FLY_HURT, BIG_FLY_DIE,                   //ENEMIES
  DOOR_LOCK, DOOR_UNLOCK,                               //ROOMS
  PLAYER_HURT, PLAYER_DIE, PLAYER_SHOOT,                //PLAYER
  UPGRADE, DOWNGRADE
  
}

///
///Handles the event sounds and the music loop
///
class SoundPlayer{
  
  private Minim minim;
  
  private AudioSample[] sounds;
  
  private AudioPlayer intro;
  private AudioPlayer song;
  private boolean playedIntro;
  
  private SoundObserver obs;
  
  private boolean musicMuted;
  
  SoundPlayer(PApplet app){
    generate(app);
  }
  
  
  SoundObserver getObserver(){return obs;}
  
  ///
  ///Creates the sound handlers
  ///
  void generate(PApplet app){
    
    minim = new Minim(app);
    minim.debugOff();
    obs = new SoundObserver();
    sounds = new AudioSample[Sounds.values().length];
    
    
    //Sounds.VALUE.ordinal();   -> value to index
    //Sounds.values()[index];              -> index to value
    
    
    loadSounds();
    //toggleMusic();
    
  }
  
  ///
  ///Add a sound creating entity
  ///
  void addObservable(Observable nobs){
    if(nobs != null && obs != null){
      obs.addObservable(nobs);
    }
  }
  
  
  ///
  ///Updates the music and checks for sounds to be played
  ///
  void update(){
    
    handleMusic();
    
    for(Observable part : obs.obs){
      
      if(part.isNotified()){
        
        Sounds partSound = ((SoundObservable)part).getSound();
        int index = Sounds.valueOf(partSound.toString()).ordinal();
        
        if(sounds[index] != null){
          sounds[index].trigger();
        }
        
        
        part.confirmNotification();
      }
      
    }
    
    
  }
  
  ///
  ///Loops the theme when the intro has finished playing
  ///
  void handleMusic(){
    if(!playedIntro){
      intro.cue(0);
      intro.play();
      playedIntro = true;
    }else {
      if(!intro.isPlaying()){
        if(!song.isPlaying()){
          song.cue(0);
          song.play();
        }
      }
    }
  }
  
  ///
  ///Loads all the sounds
  ///
  void loadSounds(){
    
    sounds[Sounds.PLAYER_HURT.ordinal()] = minim.loadSample("data/sfx/player/playerhurt.wav");
    sounds[Sounds.PLAYER_DIE.ordinal()] = minim.loadSample("data/sfx/player/playerdeath.wav");
    sounds[Sounds.PLAYER_SHOOT.ordinal()] = minim.loadSample("data/sfx/player/playerthrow.wav");
    
    sounds[Sounds.PROJECTILE_IMPACT.ordinal()] = minim.loadSample("data/sfx/projectile/impact.wav");
    
    
    sounds[Sounds.FLY_DIE.ordinal()] = minim.loadSample("data/sfx/enemy/flydeath.wav");
    sounds[Sounds.BIG_FLY_HURT.ordinal()] = minim.loadSample("data/sfx/enemy/bigflyhurt.wav");
    sounds[Sounds.BIG_FLY_DIE.ordinal()] = minim.loadSample("data/sfx/enemy/bigflydeath.wav");
    
    
    sounds[Sounds.DOOR_LOCK.ordinal()] = minim.loadSample("data/sfx/room/doorlock.wav");
    sounds[Sounds.DOOR_UNLOCK.ordinal()] = minim.loadSample("data/sfx/room/doorunlock.wav");
    
    
    sounds[Sounds.UPGRADE.ordinal()] = minim.loadSample("data/sfx/misc/upgrade.wav");
    sounds[Sounds.DOWNGRADE.ordinal()] = minim.loadSample("data/sfx/misc/downgrade.wav");
    
    for(int i = 0; i < sounds.length; i++){
      
      if(sounds[i] != null){
        sounds[i].setGain(-3);
      }
      
    }
    
    intro = minim.loadFile("data/sfx/music/playingintro.wav");
    intro.setGain(-3);
    
    song = minim.loadFile("data/sfx/music/playingtheme.wav");
    song.setGain(-3);
    
    
    musicMuted = false;
    
    resetMusic();
    
  }
  
  ///
  ///Restarts the intro
  ///
  void resetMusic(){
    
    playedIntro = false;
    if(intro.isPlaying()){
      intro.pause();
    }
    if(song.isPlaying()){
      song.pause();
    }
    
  }
  
  ///
  ///Removes all sound-generating entities
  ///
  void clearObservables(){
    
    obs.obs.clear();
    
  }
  
  ///
  ///Turns on or off the music
  ///
  void toggleMusic(){
    
    if(musicMuted){
      
      intro.unmute();
      song.unmute();
      
    }else {
      
      intro.mute();
      song.mute();
      
    }
    
    musicMuted = !musicMuted;
    
  }
  
}
