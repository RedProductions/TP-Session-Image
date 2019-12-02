class ParticleObservable extends Observable{
  
  private ParticleParams params;
  public ParticleParams getParams(){return params;}
  public void setParticleParams(PVector spawnPoint, ParticleType type){
    params = new ParticleParams();
    params.spawnPoint = spawnPoint.copy();
    params.type = type;
  }
  
}



class ParticleParams{
  
  public PVector spawnPoint;
  public ParticleType type;
  
}
