/*##################################################################################################
 Abstract geometry drawing transformation. Extends the abstract class drawing which in turn is an
 extension of PImage.
 Author: Carl Malmstroem
 SFUID:301294715
 ###################################################################################################*/

class abstractGeo extends drawing {

  /* #################### Constructor #################################################################
   Generates a uniformly random light background and then traces the drawn pixels in the base sketch.
   The pixels x- and y-positions are continously stored in array holding the last 1000 positions.
   Then shapes are painted (rectangles, ellipses and triangles) using these positions by going through
   the array at regular intervals and finding points close to each other. The freedom parameter essentially
   dictates how true the shapes track the outlines of the base sketch.
   ####################################################################################################*/
  abstractGeo (drawing baseSketch, int freedom) { 
    this.width = baseSketch.width;
    this.height = baseSketch.height;
    int[] startX = new int[1000];            //Arrays for x- and y-positions that holds the position
    int[] startY = new int[1000];            //of the last 1000 colored pixels
    int lastX = 0;                           //Variables storing the position of the last drawn shape
    int lastY = 0;
    int index = 0;
    loadPixels();
    for (int i=0; i<pixels.length; i++)      //Loop to fill the background
      pixels[i] = color(random(235, 255), random(235, 255), random(235, 255));
    PGraphics pg = createGraphics( this.width, this.height );
    pg.set(0, 0, this);
    pg.beginDraw();
    pg.rectMode(CORNERS);
    pg.ellipseMode(CORNERS);
    baseSketch.loadPixels();
    for (int i=0; i<pixels.length; i++) {
      if (baseSketch.pixels[i] < color(240)) {
        int y = int(i/width);
        int x = i-y*width;
        if (index == 0) {                    //Initializes the array by filling it with the first pixel's values
          for (int j=0; j<startX.length; j++) {
            startX[j] = x;
            startY[j] = y;
          }
        }
        if (index >= startX.length)          //Resets the index when it reaches the end of the array
          index = 0;
        startX[index] = x;                   //Updates the array with the current pixel's values
        startY[index] = y;
        index++;
        if ( x > lastX + 12 || y > lastY + 12) {    //Only loops through the array to find new shapes when far enough away from the last shapes drawn
          color c = color(random(100, 180), random(100, 180), random(100, 180), 4);
          pg.stroke(color(baseSketch.pixels[i], 30));
          pg.strokeWeight(0.8);
          pg.fill(c);
          int type = int(random(3));                              //Random variable to decide shape
          for (int j=0; j<startX.length; j++) {                   //Loops through the x- and y-position arrays
            if (abs(startX[j]-x) > 20 && abs(startX[j]-x) < 60) { //Looks for points close enough to current pixel
              lastX = x;                                          //When point found update the position of last drawn shape
              lastY = y;
              switch(type) {                                      //Drawing shapes between found point and current pixel
              case 0:                                             //A randomness using the freedom parameter is added
                pg.rect(startX[j] + random(-freedom*4, freedom*4), startY[j] + random(-freedom*4, freedom*4), x  + random(-freedom*4, freedom*4), startY[j] + random(20, 60) + random(-freedom*4, freedom*4));
                break;
              case 1:
                pg.ellipse(startX[j] + random(-freedom*4, freedom*4), startY[j] + random(-freedom*4, freedom*4), x + random(-freedom*4, freedom*4), startY[j] + random(20, 60) + random(-freedom*4, freedom*4));
                break;
              case 2:
                pg.triangle(startX[j] + random(-freedom*4, freedom*4), startY[j] + random(-freedom*4, freedom*4), x + random(-freedom*4, freedom*4), startY[j] + random(20, 60) + random(-freedom*4, freedom*4), random(startX[j], x) + random(-freedom*4, freedom*4), startY[j] + random(20, 60) + random(-freedom*4, freedom*4));
                break;
              }
              if (j<startX.length-5)                              //Jumps through the array to draw fewer shapes
                j += 5;
              if (random(10)<1 && j<startX.length-freedom)        //Adding an extra jump based on freedom of transformation
                j += freedom;
            } 
            if (abs(startY[j]-y) > 20 && abs(startY[j]-y) < 60) {  //Again looks for points but checks distance in Y instead
              lastX = x;
              lastY = y;
              switch(type) {
              case 0:
                pg.rect(startX[j] + random(-freedom*4, freedom*4), startY[j] + random(-freedom*4, freedom*4), startX[j] + random(20, 60) + random(-freedom*4, freedom*4), y + random(-freedom*4, freedom*4));
                break;
              case 1:
                pg.ellipse(startX[j] + random(-freedom*4, freedom*4), startY[j] + random(-freedom*4, freedom*4), startX[j] + random(20, 60) + random(-freedom*4, freedom*4), y + random(-freedom*4, freedom*4));
                break;
              case 2:
                pg.triangle(startX[j] + random(-freedom*4, freedom*4), startY[j] + random(-freedom*4, freedom*4), startX[j] + random(20, 60) + random(-freedom*4, freedom*4), y + random(-freedom*4, freedom*4), random(startX[j], startX[j] + random(20, 60)) + random(-freedom*4, freedom*4), random(startY[j], y) + random(-freedom*4, freedom*4));
                break;
              }
              if (j<startX.length-5)
                j += 10;
              if (random(10)<1 && j<startX.length-freedom)
                j += freedom;
            }
          }
        }
      }
    }
    pg.endDraw();
    pg.loadPixels();
    arrayCopy(pg.pixels, this.pixels);
    this.updatePixels();
    done();
  }
  /* #################### Paint #######################################################################
   Ten x- and y-positions between last and current mouse position are stored in an array.
   Then shapes are painted (rectangles, ellipses and triangles) using these positions.
   ####################################################################################################*/
  void paint (int x, int y, int px, int py, int strokeW, color pColor, int freedom) {
    color c = color(random(100, 180), random(100, 180), random(100, 180), 5);
    int[] startX = new int[10];            //Arrays for x- and y-positions between mouse positions
    int[] startY = new int[10];
    float distX = (x-px)/startX.length;    //Splits the distance in equal parts
    float distY = (y-py)/startY.length;
    for (int i=0; i<startX.length; i++) {  //Fills the arrays with the positions
      startX[i] = int(px + distX*(i+1));
      startY[i] = int(py + distY*(i+1));
    }
    PGraphics pg = createGraphics( this.width, this.height );
    pg.set(0, 0, this);
    pg.beginDraw();
    pg.rectMode(CORNERS);
    pg.ellipseMode(CORNERS);
    if (strokeW == 0) {                    //Checks if user has selected eraser
      pg.stroke(245);                      //In such case just draws a line between
      pg.strokeWeight(20);                 //mouse positions using background color
      pg.line( x, y, px, py );
    } else {
      pg.stroke(pColor, 20);
      pg.strokeWeight(0.8);                //Draws shapes through same procedure as in constructor
      pg.fill(c);                          //but doesn't check distance between point and instead randomly
      int type = int(random(3));           //generates end points for the shapes
      for (int j=0; j<startX.length-1; j++) {
        switch(type) {
        case 0:
          pg.rect(startX[j] + random(-freedom*4, freedom*4), startY[j] + random(-freedom*4, freedom*4), startX[j] + random(20, 60) + random(-freedom*4, freedom*4), startY[j] + random(20, 60) + random(-freedom*4, freedom*4));
          pg.rect(startX[j] + random(-freedom*4, freedom*4), startY[j] + random(-freedom*4, freedom*4), startX[j] + random(20, 60) + random(-freedom*4, freedom*4), startY[j] + random(20, 60) + random(-freedom*4, freedom*4));
          break;
        case 1:
          pg.ellipse(startX[j] + random(-freedom*4, freedom*4), startY[j] + random(-freedom*4, freedom*4), startX[j] + random(20, 60) + random(-freedom*4, freedom*4), startY[j] + random(20, 60) + random(-freedom*4, freedom*4));
          pg.ellipse(startX[j] + random(-freedom*4, freedom*4), startY[j] + random(-freedom*4, freedom*4), startX[j] + random(20, 60) + random(-freedom*4, freedom*4), startY[j] + random(20, 60) + random(-freedom*4, freedom*4));
          break;
        case 2:
          pg.triangle(startX[j] + random(-freedom*4, freedom*4), startY[j] + random(-freedom*4, freedom*4), startX[j] + random(20, 60) + random(-freedom*4, freedom*4), startY[j] + random(20, 60) + random(-freedom*4, freedom*4), startX[j] + random(-freedom*4, freedom*4), startY[j] + random(-freedom*4, freedom*4));
          pg.triangle(startX[j] + random(-freedom*4, freedom*4), startY[j] + random(-freedom*4, freedom*4), startX[j] + random(20, 60) + random(-freedom*4, freedom*4), startY[j] + random(20, 60) + random(-freedom*4, freedom*4), startX[j] + random(-freedom*4, freedom*4), startY[j] + random(-freedom*4, freedom*4));
          break;
        }
      }
    }
    pg.endDraw();
    pg.loadPixels();
    this.loadPixels();
    arrayCopy(pg.pixels, this.pixels);
    this.updatePixels();
  }
  /* #################### Paint again #################################################################
   Draws larger and larger rectangles rotated around the mouse position
   ####################################################################################################*/
  void paintAgain (int x, int y, int delay, int strokeW, color pColor, int freedom) {
    if (strokeW == 0)          //If user has selected eraser, just calls regular paint function instead
      this.paint(x, y, x+1, y+1, strokeW, pColor, freedom);
    else {
      color c = color(random(100, 180), random(100, 180), random(100, 180), 2);
      PGraphics pg = createGraphics( this.width, this.height );
      pg.set(0, 0, this);
      pg.beginDraw();
      pg.strokeWeight(strokeW);
      pg.stroke(pColor, 12);
      pg.fill(c);
      pg.pushMatrix();
      pg.translate(x, y);      //Translating to mouse position
      pg.rotate(2*delay);      //Rotation dependent on delay at current position
      pg.rect(-2*delay, -2*delay, 4*delay, 4*delay);
      pg.popMatrix();
      pg.endDraw();
      pg.loadPixels();
      this.loadPixels();
      arrayCopy(pg.pixels, this.pixels);
      this.updatePixels();
    }
  }
}

