class Star {
  //CLASS VARIABLES
  //color c = color(random(160, 290), 100, random(50));
  PVector pos, vel;
  Star [] s;
  float alpha;
  int counter;



  //CONSTRUCTOR
  Star(Star [] stars) {
    s = stars;
    pos =  new PVector(random(widthS), random(heightS));
    vel =  new PVector(random(-1, 1), random(6));
    alpha = 50;
  }

  // CLASS FUNCTIONS
  void move() {
    pos.add(vel);
  }

  void display() {
    //draw the stars themselves
    stroke(255);
    strokeWeight(6);
    point(pos.x, pos.y);
  }

  //make them fall from the top if they reach the bottom and bounce off the right 
  // and left sides of the screen
  void checkBoundries() {
    if (pos.x<0 || pos.x>width) {
      vel.x*=-1;
    } 
    if (pos.y>height) {
      pos.y = 0;
    }
  }


  void shapes(int index) {

    pushStyle();

    //style
    noFill();
    strokeWeight(3);
    stroke(255, alpha);


    for (int i = index+1; i<s.length; ++i) {
      // counter to put a limit on the size of constellations
      counter = 0;

      //checks position of other stars
      if (distsq(pos.x, pos.y, s[i].pos.x, s[i].pos.y)<sq(150)) {

        //map out the alpha value of the color to the distance
        // the further --> the more transparent
        alpha = map(distsq(pos.x, pos.y, s[i].pos.x, s[i].pos.y), 0, widthS*widthS/5, 0, 450);

        counter++;
        // vertex(s[i].pos.x, s[i].pos.y);        //made a change here -->

        //used lines because they are faster
        line(pos.x, pos.y, s[i].pos.x, s[i].pos.y);

        //limits the number of connected stars
        if (counter>7) {
          break;
        }
      }
    }
  }
}