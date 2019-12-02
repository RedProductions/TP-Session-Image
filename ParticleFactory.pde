enum ParticleType{
  
  BLOOD,
  MEGABLOOD,
  PAPER,
  STAR
  
}


class ParticleFactory{
  
  
  
  Particle getParticle(ParticleType type){
    
    switch(type){
      
      case BLOOD:
        return new BloodParticle();
      case MEGABLOOD:
        Particle part = new BloodParticle();
        part.setMega();
        return part;
      case PAPER:
        return new PaperParticle();
      case STAR:
        return new StarParticle();
      
      
      default:
        return null;
      
    }
    
    
  }
  
  
}
