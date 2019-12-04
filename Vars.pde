Enveloppe env;


PVector screenSize;


///
///Loads all the images
///
void generateTileSets(){
  
  RoomTileSet.generate(this);
  PlayerTileSet.generate(this);
  ProjectileTileSet.generate(this);
  FlyTileSet.generate(this);
  
  ParticleTileSet.generate(this);
  
  
  TILE_SIZE_PIXELS = width/VIEWPORT_GRID_RATIO;
  
}
