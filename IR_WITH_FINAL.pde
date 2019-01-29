//IMPORT THE KINECT LIBRARIES
import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;


//INITIALIZE GLOBAL VARIABLES FOR KINECT AND IR ANALYSIS
Kinect2 kinect2;
float threshold = 8;
float bri = 0;
int loc;

//THE DRAWN VECTORS AND THE STARS
Ball [] b = new Ball[3700];
Star [] s = new Star[300];


//GLOBAL WIDTH AND HEIGHT VARIABLES BECAUSE CLASSES ARE WEIRD
float widthS = 1200;
float heightS = 1920;

//IMAGES REQUIRED FOR THE SKETCH
PImage ir;
PImage img;
PImage largeimg;

//THIS IS NOT REQUIRED AND IS ONLY NEEDED FOR BLURRED IMAGES
PShader blur;

void setup() {

  size(1200, 1920, P2D);
  smooth();
  //BEGIN KINECT DATA 
  kinect2 = new Kinect2(this);
  kinect2.initIR();

  //GET THE IR IMAGE
  ir = kinect2.getIrImage();

  //START UP KINECT
  kinect2.initDevice();

  blur = loadShader("blur.glsl");

  //MAKE AN EMPTY RGB IMAGE THAT IS THE SAME SIZE AS THE IR IMAGE
  img = createImage(ir.width, ir.height, RGB);  

  //INITIALIZE THE VECTORS FOR DRAWING SHAPES
  for (int i = 0; i<b.length; ++i) {
    b[i] = new Ball(b, img);
  }

  //INITIALIZE THE STARS
  for (int i = 0; i<s.length; ++i) {
    s[i] = new Star(s);
  }
}


void draw() {
  background(0);
  // KEEP GETTING THE IR IMAGE EVERYFRAME
  ir = kinect2.getIrImage();

  //LOAD EACH PIXEL IN THE IR IMAGE AND THE EMPTY IMAGE
  ir.loadPixels();
  img.loadPixels();

  //LOOP THROUGH THE INPUT IR IMAGE
  for (int i = 0; i<ir.width; ++i) {
    for (int j = 0; j<ir.height; ++j) {
      loc = i + j*ir.width;

      //AS IR IMAGE IS ONLY B&W WE ONLY NEED THE BRIGHTNESS
      bri = brightness(ir.pixels[loc]);

      //COMPARE IT TO THE THRESHOLD
      //ADD A COLOR PIXEL AT THE CORRESPONDING POSITION IN THE EMPTY 
      //IMAGE BRIGHTNESS IN THE IR IMAGE IS GREATER THAN THRESHOLD
      if (bri>threshold) {
        img.pixels[loc] = color(bri +(bri/(bri+1))+100, 0, 255 - bri);
      } 
      //BLACK/ NO COLOR IF SMALLER THAN THRESHOLD
      else {
        img.pixels[loc] = color(0, 0, 0, 0);
      }
    }
  }
  
  //UPDATATE THE IMAGE TO SAVE THE PIXELS ON IT 
  img.updatePixels();
  
  //RESIZE IT SO IT WORKS ON ANY SCREEN SIZE
  largeimg = img.get(0, 0, img.width, img.height);
  largeimg.resize(width, height);

// OPTIONAL DRAW THE BLURRED IMAGE IN THE BACKGROUND
// FOR CLEARER EFFECTS
  //image(largeimg, 0, 0, width, height);
  ////filter(blur);
  
  //BEGIN DRAWING AND MOVING THE STARS AND CONSTELLATIONS
  for (int i = 0; i<s.length; ++i) {
    s[i].display();
    s[i].move();
    s[i].checkBoundries();
    s[i].shapes(i);
  }

// DRAW THE SHAPES CORRESPONDING TO INTERACTING BODIES
  for (int i = 0; i<b.length; ++i) {
    b[i].img = largeimg;
    //b[i].display();
    b[i].move();
    b[i].checkBoundries();
    b[i].shapes(i);
    //b[i].morefilled(i);
  }
}