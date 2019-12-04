///
///Types of Particle that can be created
///
enum ParticleType{
  
  BLOOD, MEGABLOOD,
  PAPER,
  STAR
  
}

///
///Generates a Particle from its given type
///
class ParticleFactory{
  
  
  ///
  ///Gives the particle from its given type
  ///
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
