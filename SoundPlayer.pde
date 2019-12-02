import ddf.minim.*;

enum Sounds{
  
  FIRE, PROJECTILE_IMPACT,
  FLY, FLY_DEATH, BIG_FLY, BIG_FLY_DEATH, 
  DOOR_LOCK, DOOR_UNLOCK,
  PLAYER_HURT
  
}

static class SoundPlayer{
  
  static Minim minim;
  
  static void generate(PApplet app){
    
    minim = new Minim(app);
    
  }
  
}
