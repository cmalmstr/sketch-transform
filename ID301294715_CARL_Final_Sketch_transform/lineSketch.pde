/*##################################################################################################
 Basic sketch drawing. Extends the abstract class drawing which in turn is an
 extension of PImage.
 Author: Carl Malmstroem
 SFUID:301294715
 ###################################################################################################*/

class lineSketch extends drawing {

  /* #################### Constructor #################################################################
   Since the basic sketch is always stored the constructor is only needed to create blank sketches of
   specified size.
   ####################################################################################################*/
  lineSketch (int w, int h) {
    this.width = w;
    this.height = h;
    loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = color(255);
    this.updatePixels();
    done();
  }
  /* #################### Paint #######################################################################
   Adds to the canvas by drawing lines between current and previous mouse positions. Stroke weight and
   color are determined by the passed arguments which in turn is set from the control panel
   ####################################################################################################*/
  void paint (int x, int y, int px, int py, int strokeW, color pColor, int freedom) {  
    PGraphics pg = createGraphics( this.width, this.height );
    pg.set(0, 0, this);
    pg.beginDraw();
    pg.stroke(pColor);
    pg.strokeWeight(strokeW);
    if (strokeW == 0) {          //If the user has selected eraser
      pg.stroke(255);            //Draw a larger white line
      pg.strokeWeight(20);
    }
    pg.line( x, y, px, py );
    pg.endDraw();
    pg.loadPixels();
    this.loadPixels();
    arrayCopy(pg.pixels, this.pixels);
    this.updatePixels();
  }
  /* #################### Paint again ################################################################
   Paint again (called when mouse held in static position) is not used for the basic line sketches.
   But the function must be present as it is specified in drawing class
   ####################################################################################################*/
  void paintAgain (int x, int y, int delay, int strokeW, color pColor, int freedom) {
  }
}

