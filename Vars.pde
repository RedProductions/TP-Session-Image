Enveloppe env;


PVector screenSize;



void generateTileSets(){
  
  RoomTileSet.generate(this);
  PlayerTileSet.generate(this);
  ProjectileTileSet.generate(this);
  FlyTileSet.generate(this);
  
  ParticleTileSet.generate(this);
  
  
  TILE_SIZE_PIXELS = width/VIEWPORT_GRID_RATIO;
  
}
