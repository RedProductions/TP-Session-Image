///
///Modifier on the Projectile 's numerical values
///
enum ValuesModifiers{
  
  SIZE, SPEED, FIRERATE
  
}

///
///Modifier on the Projectile 's behaviour and on the Projectiles spawning
///
enum AttributesModifiers{
  
  PIERCING, SPLIT, BOOMERANG, RANDOMHUE, BOUNCY,
  BACKWARDS, TRISHOT, QUADSHOT, QUADDIR, WAVE,
  HOVER
  
}

///
///Modifier on the Player 's numerical values
///
enum PlayerModifiers{
  
  SPEED, HEALTH
  
}

///
///Modifies the Projectile behaviour, spawning of Projectiles and the Player stats
///
class Modifier{
  
  private float[] valuesModifiers;
  private float[] playerModifiers;
  private boolean[] attributesModifiers;
  
  private boolean upgrade;
  
  Modifier(){
    
    valuesModifiers = new float[ValuesModifiers.values().length];
    
    for(int i = 0; i < valuesModifiers.length; i++){
      valuesModifiers[i] = 1;
    }
    
    playerModifiers = new float[ValuesModifiers.values().length];
    
    for(int i = 0; i < playerModifiers.length; i++){
      playerModifiers[i] = 1;
    }
    
    //start given health to +0
    playerModifiers[PlayerModifiers.HEALTH.ordinal()] = 0;
    
    
    attributesModifiers = new boolean[AttributesModifiers.values().length];
    
    for(int i = 0; i < attributesModifiers.length; i++){
      attributesModifiers[i] = false;
    }
    
    
  }
  
  float[] getValueMods(){return valuesModifiers;}
  float[] getPlayerMods(){return playerModifiers;}
  boolean[] getAttributeMods(){return attributesModifiers;}
  
  ///
  ///Combine its current values to the values of the given modifier
  ///
  void combine(Modifier mod){
    
    float[] otherVals = mod.getValueMods();
    float[] otherPlay = mod.getPlayerMods();
    boolean[] otherAtt = mod.getAttributeMods();
    
    for(int i = 0; i < valuesModifiers.length; i++){
      valuesModifiers[i] *= otherVals[i];
    }
    
    for(int i = 0; i < playerModifiers.length; i++){
      if(i == PlayerModifiers.HEALTH.ordinal()){
        playerModifiers[i] += otherPlay[i]*2;      //*2 to give full hearts (hearts are 2 hp)
      }else {
        playerModifiers[i] *= otherPlay[i];
      }
    }
    
    
    for(int i = 0; i < attributesModifiers.length; i++){
      attributesModifiers[i] = attributesModifiers[i] || otherAtt[i];
    }
    
  }
  
  float getVal(ValuesModifiers val){
    
    return valuesModifiers[val.ordinal()];
    
  }
  
  float getPla(PlayerModifiers val){
    
    return playerModifiers[val.ordinal()];
    
  }
  
  boolean getAtt(AttributesModifiers val){
    
    return attributesModifiers[val.ordinal()];
    
  }
  
  boolean isUpgrade(){return upgrade;}
  void setUpgrade(boolean nupgrade){
    upgrade = nupgrade;
  }
  
  ///
  ///Reset the player's attributes after they have been applied
  ///
  void resetPlayerModifiers(){
    
    playerModifiers[PlayerModifiers.HEALTH.ordinal()] = 0;
    playerModifiers[PlayerModifiers.SPEED.ordinal()] = 1;
    
  }
  
}
