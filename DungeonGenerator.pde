
void setup(){
  noLoop();
  size(500,500);
  background(64);
  noStroke();
  fill(200);
  randomSeed(0);
  
}

void draw(){
  GenerateWorld world = new GenerateWorld();
  translate(width/2,height/2);
  world.generateWorld();
}