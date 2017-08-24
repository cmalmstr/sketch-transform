/*##################################################################################################
 Fine sketching drawing transformation. Extends the abstract class drawing which in turn is an
 extension of PImage.
 Author: Carl Malmstroem
 SFUID:301294715
 ###################################################################################################*/

class fineLines extends drawing {
  float maxLength;
  color c;
  /* #################### Constructor #################################################################
   Generates a uniformly random light background and then traces the drawn pixels in the base sketch.
   For each colored pixel it draws a line extending randomly out from the pixel. The range of the extent
   of the lines is updated through each loop resulting in parts of the drawing having shorter lines
   and parts of it having longer lines. The freedom parameter controls the brightness and prevalence
   of colored lines and the rate of change of line length.
   ####################################################################################################*/
  fineLines (drawing baseSketch, int freedom) { 
    this.width = baseSketch.width;
    this.height = baseSketch.height;
    maxLength = random(4, 6*freedom);                                 //Range of the extent of the lines
    c = color(random(25*freedom), random(25*freedom), random(25*freedom));
    loadPixels();
    for (int i=0; i<pixels.length; i++)                               //Loop to fill the background
      pixels[i] = color(random(235, 255), random(235, 255), random(235, 255));
    PGraphics pg = createGraphics( this.width, this.height );
    pg.set(0, 0, this);
    pg.beginDraw();
    pg.strokeWeight(0.5);
    baseSketch.loadPixels();
    for (int i=0; i<baseSketch.pixels.length; i++) {
      if (baseSketch.pixels[i] <= color(240)) {
        int y = int(i/width);
        int x = i-y*width;
        if (int(random(0, freedom/2))<1)                              //Selects base sketch color or randomly generated color using probability
          pg.stroke(color(baseSketch.pixels[i], 100));
        else
          pg.stroke(c);
        pg.pushMatrix();
        pg.translate( x, y );
        pg.line( -random(maxLength), -random(maxLength), random(maxLength), random(maxLength) );
        pg.popMatrix();
        maxLength += freedom * random( -0.05, 0.05 );                //Change the range of line length for each loop
      }
    }
    pg.endDraw();
    pg.loadPixels();
    arrayCopy(pg.pixels, this.pixels);
    this.updatePixels();
    done();
  }
  /* #################### Paint #######################################################################
   Loops through the distance between current and previous mouse location and draw lines extending randomly
   out from positions spaced out equally between the mouse locations. The range of the extent
   of the lines is updated through each loop resulting in parts of the drawing having shorter lines
   and parts of it having longer lines. The freedom parameter controls the brightness and prevalence
   of colored lines and the rate of change of line length.
   ####################################################################################################*/
  void paint (int x, int y, int px, int py, int strokeW, color pColor, int freedom) {  
    PGraphics pg = createGraphics( this.width, this.height );
    pg.set(0, 0, this);
    pg.beginDraw();
    pg.strokeWeight(0.5);
    if (strokeW == 0) {                        //If user has selected eraser just draw a straight line
      pg.stroke(245);                          //Using background color
      pg.strokeWeight(20);
      pg.line( x, y, px, py );
    } else {
      for (int i = 0; i<= strokeW; i++) {      //The user selected stroke weight determines the number of
        if (int(random(0, freedom/2))<1)       //lines drawn
          pg.stroke(color(pColor, 100));       //Probability driven color selection for the lines to draw
        else
          pg.stroke(c);
        pg.pushMatrix();
        pg.translate( x, y );
        for (int j = 0; j<5; j++) {            //Loops through the distance between mouse and pmouse
          pg.line( -random(maxLength), -random(maxLength), random(maxLength), random(maxLength) );
          pg.line( -random(maxLength), -random(maxLength), random(maxLength), random(maxLength) );
          pg.translate( (x-px)/4, (y-py)/4);   //Translating the origin of the lines uniformly
        }
        pg.popMatrix();
        maxLength += freedom * random( -0.05, 0.05 );      //Change the range of line length for each loop
      }
    }
    pg.endDraw();
    pg.loadPixels();
    this.loadPixels();
    arrayCopy(pg.pixels, this.pixels);
    this.updatePixels();
  }
  /* #################### Paint again #################################################################
   Holding the mouse pressed in the same location results in a gradual increase or decrease of the range
   of line length used for future sketching. Which button is held determines if the range should increase
   or decrease.
   ####################################################################################################*/
  void paintAgain (int x, int y, int delay, int strokeW, color pColor, int freedom) {
    if (strokeW == 0)                            //If user has selected eraser just call paint
      this.paint(x, y, x+1, y+1, strokeW, pColor, freedom);
    else {                                       //Updating the range of line length depending on mouse button held
      if (mouseButton == LEFT)
        maxLength += freedom * random( 0.1 );
      else if (mouseButton == RIGHT)
        maxLength -= freedom * random( 0.1 );
      this.paint(x, y, x, y, strokeW, pColor, freedom);  //Calling the paint function to draw some lines at this position
    }
  }
}

