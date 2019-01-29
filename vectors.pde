class Ball {
  //CLASS VARIABLES
  // original color gets overwritten later in this specific sketch
  color c = color(random(150, 350), random(50, 100), random(80, 100));

  PVector pos, vel;

  //takes a list to check where all the other objects are
  Ball [] b;

  //maximum shape size
  float size;

  //variables to analyze image
  PImage img;
  color thresholdColor = color(0);
  float alpha =0;

  //CONSTRUCTOR
  Ball(Ball [] balls, PImage img_ ) {
    b = balls;
    img = img_;

    //position and shape related variables
    pos =  new PVector(random(width), random(height));
    vel =  new PVector(8, 8);
    vel.mult(random(-1, 1));
    size = 80;
  }

  // CLASS FUNCTIONS
  void move() {
    pos.add(vel);

    //get the color of the pixel at which the object 
    //is positioned at as it moves
    c = img.get(int(pos.x), int(pos.y));
  }


  //display function is a mode that draws randomly sized circles within the shape
  void display() {
    pushStyle();
    strokeWeight(random(40));
    stroke(c);
    fill(c);
    point(pos.x, pos.y);
    popStyle();
  }


  // the morefilled function mode draws the shape with squares inside as well which gives them a shape 
  // that is more filled thus easy to recognize that it is the individual's body
  void morefilled(int ind) {
    beginShape();
    pushStyle();

    // gets the color of the pixel where the object is 
    c = img.get(int(pos.x), int(pos.y));

    //style
    strokeWeight(0);
    fill(c, alpha);
    stroke(c, alpha);

    // begins the shape where the specific object is
    vertex(pos.x, pos.y);

    // draws a rectangle at the object position
    rectMode(CENTER);
    rect(pos.x, pos.y, 40, 40);

    //loops through all the other objects excluding the ones that have previously been checked
    // the counter variable enables us to specify the shape complexity, the larger the counter the more vertices
    for (int i = ind+1, counter = 0; i<b.length; ++i) {
      // it first has to check if the point it is at has a color input or if the pixel is black/blank
      if (c > thresholdColor) {
        alpha = 100;
        //assign slightly randomized value for the color of the shape
        fill(red(c) + random(50), green(c)+50, blue(c) + random(400));

        //check how far away the other objects are
        if (distsq(pos.x, pos.y, b[i].pos.x, b[i].pos.y)<sq(constrain(size, 0, 400))) {
          // if they are close connect both points
          vertex(b[i].pos.x, b[i].pos.y);

          //increment counter and break the loop if it becomes greater than 1 which corresponds to triangles
          //generally do not go above 4 or 3 because it makes it much slower
          ++counter;
          if (counter>1) {
            break;
          }
        }
      } else {
        // if objects are far away make them transparent
        alpha = 0;
      }
    }
    endShape(CLOSE);
    popStyle();
  }

  //make them bounce off the screen
  void checkBoundries() {
    if (pos.x<0 || pos.x>(width)) {
      vel.x*=-1;
    } 
    if (pos.y<0 || pos.y>height) {
      vel.y*=-1;
    }
  }


  //another mode but not as nice --> the function follows the same logic
  void lines() {
    pushStyle();
    strokeWeight(0);
    stroke(c, 90);
    c = img.get(int(pos.x), int(pos.y));
    for (int i = 0, counter = 0; i<b.length; ++i) {
      if (c > thresholdColor) {
        if (distsq(pos.x, pos.y, b[i].pos.x, b[i].pos.y)<sq(constrain(size, 0, 400))) {
          line(pos.x, pos.y, pos.x+ random(-30, 30), pos.y+ random(-30, 30));
          ++counter;
          if (counter>1) {
            break;
          }
        }
      }
    }
  }



  void shapes(int ind) {
    beginShape();
    pushStyle();
    
    //style
    fill(c, random(80, 100));
    strokeWeight(0);
    stroke(0, 80);
    
    //get pixel color
    c = img.get(int(pos.x), int(pos.y));
    
    //place a vertex at the object's position
    vertex(pos.x, pos.y);
    
    //--> check above logic for this loop
    for (int i = ind+1, counter = 0; i<b.length; ++i) {
      if (c > thresholdColor) {
        if (distsq(pos.x, pos.y, b[i].pos.x, b[i].pos.y)<sq(constrain(size, 0, 400))) {
          vertex(b[i].pos.x, b[i].pos.y);
          ++counter;
          if (counter>1) {
            break;
          }
        }
      }
    }

    endShape(CLOSE);
    popStyle();
  }
}

//redefines distance which makes sketch actually faster
float distsq(float x1, float y1, float x2, float y2) {
  float dist1 = ((sq(x1-x2))+sq(y1-y2)) ;
  return dist1;
}