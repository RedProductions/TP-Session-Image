///
///Observable that notifies when and what Particle should be spawned
///
class ParticleObservable extends Observable{
  
  private ParticleParams params;
  public ParticleParams getParams(){return params;}
  
  ///
  ///Gives the parameters of the spawn
  ///
  public void setParticleParams(PVector spawnPoint, ParticleType type){
    params = new ParticleParams();
    params.spawnPoint = spawnPoint.copy();
    params.type = type;
  }
  
}


///
///Parameters given to the spawning Particle
///
class ParticleParams{
  
  public PVector spawnPoint;
  public ParticleType type;
  
}
