PImage base;
PImage circleMask;
int r = 300;
int numberOfCircles = 6;
PImage[] circles;
PImage[] circleMasks;

void setup(){
  size(600, 600);
  int d = 2*r;
  //noLoop(); 
  smooth();
   
  PImage raw = loadImage("BQE.jpg");
  int startingX = 0;
  int startingY = 0;
  
  base = loadImage("BQE.jpg");
  println(base.width);
  println(base.height);
  
  int desiredWidth = 2*r;
  //should resize image to be a reasonable size
  int desiredHeight = desiredWidth / base.width;
  
  base.resize(desiredWidth, desiredHeight);
  
 
 
   circleMask = createImage(d, d, ALPHA);
   circleMask.loadPixels();
  
   //figures out the circle mask for a circle 
   for(int x = 0; x < d; x++){
     for(int y = 0; y < d; y++){
       if( pow((x-r), 2) + pow((y-r), 2) <= pow(r, 2))
         circleMask.pixels[x + y*d] = 255;
       else
         circleMask.pixels[x + y*d] = 0;
     }
   }
  circleMask.updatePixels();
  
  //////////----------------------------
  circleMasks = new PImage[numberOfCircles];
  int s = r*2;
  for(int i = 0; i < numberOfCircles; i++){
    circleMasks[i] = createImage(d, d, ALPHA);
    circleMasks[i].loadPixels();
    for(int x = 0; x < d; x++){
     for(int y = 0; y < d; y++){
       if( pow((x-r), 2) + pow((y-r), 2) <= pow(s/2, 2))
         circleMasks[i].pixels[x + y*d] = 255;
       else
         circleMasks[i].pixels[x + y*d] = 0;
     }
   }
    
    circleMasks[i].updatePixels();
    s = r*2 - i * 120;
  }
  //////////----------------------------
  
  circles = new PImage[numberOfCircles];
  //int s = r*2;
  //s = r*2;
  for(int i = 0; i < numberOfCircles; i++){
    circles[i] = base.copy();
    circles[i].mask(circleMasks[i]);
    
    //this ends up giving you a crazy zoom effect as well
    //circles[i].mask(circleMask.copy());
    //circles[i].resize(s, s);
    //s = r*2 - i * 120;
  }
}

void draw(){
  //handle the background
  background(0);
  image(base, 0, 0);
  
  //base.mask(circleMask);
  
  int runningAngle = 0;
  for(int i = 0; i < numberOfCircles; i++){
    //resizing it like this makes base unusable afterwards
    //it would be more efficient to do this once, and then to store
    //the results in an array of images
     //base.resize(s, s);
     
     rotateAndDraw(circles[i], runningAngle);
     
     runningAngle += 40* (mouseY-r)/r;
  }
  
}

//always rotates around center of window
void rotateAndDraw(PImage img, float degrees){
  pushMatrix();
  translate(r, r);
  rotate(radians(degrees));
  translate(-r, -r);
  image(img, r - img.width/2.0, r - img.height/2.0);
  popMatrix();
}

 