/*##################################################################################################
 Light painting drawing transformation. Extends the abstract class drawing which in turn is an
 extension of PImage.
 Author: Carl Malmstroem
 SFUID:301294715
 ###################################################################################################*/

class lightPaint extends drawing {

  /* #################### Constructor #################################################################
   First a uniformly noisy darkness is generated as background, to which is added probability-driven
   defects of lighter, colored spots. The lines and shapes of the base sketch are then plotted out using
   points and cumulative opacity. As the transformation is carried out defects in the form of flares
   jumping off the shapes and twirling before dying off are added. The prevalence and length of these
   flares are predicted by the user controllable transformation freedom parameter.
   ####################################################################################################*/
  lightPaint (drawing baseSketch, int freedom) { 
    this.width = baseSketch.width;
    this.height = baseSketch.height;
    loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = color(random(50), random(50), random(50));
    color noise = color(random(100, 200), random(100, 200), random(100, 200));
    color c = color(random(200, 255), random(200, 255), random(200, 255));
    PGraphics pg = createGraphics( this.width, this.height );
    pg.set(0, 0, this);
    pg.beginDraw();
    pg.noFill();
    baseSketch.loadPixels();
    for (int i=0; i<baseSketch.pixels.length; i++) {
      int y = int(i/width);
      int x = i-y*width;
      if (random(200) < 1) {                    //Probability driven addition of noise
        noise = color(random(100, 200), random(100, 200), random(100, 200));
        pg.strokeWeight(random(3));
        pg.stroke(noise, 120);
        if (random(100) < 1)                    //Stacked probabilities of larger noise particles
          pg.strokeWeight(6);
        if (random(700) < 1) {
          pg.strokeWeight(20);
          pg.stroke(noise, 50);
        }
        pg.point(x, y);
      }
      if (random(20) < 1)                       //Probability driven change of color used in drawing results in areas drawn in the same color
        c = color(random(200, 255), random(200, 255), random(200, 255));
      if (baseSketch.pixels[i] <= color(80)) {  //The color of the base sketch is evaluated in three levels to drawn light of varying brightness
        pg.strokeWeight(10);                    //Drawing point of different sizes whose opacity adds up to the final result
        pg.stroke(c, 8);
        pg.point(x, y);
        pg.strokeWeight(6);
        pg.stroke(c, 8);
        pg.point(x, y);
        pg.strokeWeight(1);
        pg.stroke(255);
        pg.point(x, y);
        if (random(4000-350*freedom) < 1) {    //Probability driven addition of detours (defects)
          detour(pg, x, y, freedom);           //Defects created in separate function
        }
      } else if (baseSketch.pixels[i] <= color(180)) {
        pg.strokeWeight(10);
        pg.stroke(c, 8);
        pg.point(x, y);
        pg.strokeWeight(6);
        pg.stroke(c, 8);
        pg.point(x, y);
        pg.strokeWeight(1);
        pg.stroke(255, 80);
        pg.point(x, y);
        if (random(4000-350*freedom) < 1) {
          detour(pg, x, y, freedom);
        }
      } else if (baseSketch.pixels[i] <= color(230)) {
        pg.strokeWeight(10);
        pg.stroke(c, 8);
        pg.point(x, y);
        pg.strokeWeight(6);
        pg.stroke(c, 8);
        pg.point(x, y);
        pg.strokeWeight(1);
        pg.stroke(255, 20);
        pg.point(x, y);
        if (random(4000-350*freedom) < 1) {
          detour(pg, x, y, freedom);
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
   The line between current and previous mouse position is plotted out using  cumulative opacity.
   Defects are added through probability controlled by the freedom parameter.
   ####################################################################################################*/
  void paint (int x, int y, int px, int py, int strokeW, color pColor, int freedom) {
    PGraphics pg = createGraphics( this.width, this.height );
    pg.set(0, 0, this);
    pg.beginDraw();
    if (strokeW == 0) {            //If user has selected eraser just draw a line
      pg.stroke(25);               //Using background color
      pg.strokeWeight(20);
      pg.line( x, y, px, py );
    } else {
      color c = color(random(200, 255), random(200, 255), random(200, 255));
      pg.strokeCap(SQUARE);       //Changing strokeCap to merge the line segments better
      pg.noFill();
      if (pColor <= color(80)) {  //The stroke color is evaluated in three levels to drawn light of varying brightness
        pg.strokeWeight(10);      //Lines of varying widths and opacity is drawn and adds up to the final result
        pg.stroke(c, 100);
        pg.line( x, y, px, py );
        pg.strokeWeight(6);
        pg.stroke(c, 100);
        pg.line( x, y, px, py );
        pg.strokeWeight(strokeW);
        pg.stroke(255);
        pg.line( x, y, px, py );
        if (random(100-9*freedom) < 1) {    //Probability driven addition of detours (defects)
          detour(pg, x, y, freedom);        //Defects are created in separate function
        }
      } else if (pColor <= color(180)) {
        pg.strokeWeight(10);
        pg.stroke(c, 100);
        pg.line( x, y, px, py );
        pg.strokeWeight(6);
        pg.stroke(c, 100);
        pg.line( x, y, px, py );
        pg.strokeWeight(strokeW);
        pg.stroke(255, 10);
        pg.line( x, y, px, py );
        if (random(100-9*freedom) < 1) {
          detour(pg, x, y, freedom);
        }
      } else if (pColor <= color(230)) {
        pg.strokeWeight(10);
        pg.stroke(c, 100);
        pg.line( x, y, px, py );
        pg.strokeWeight(6);
        pg.stroke(c, 100);
        pg.line( x, y, px, py );
        pg.strokeWeight(strokeW);
        pg.stroke(255, 5);
        pg.line( x, y, px, py );
        if (random(100-9*freedom) < 1) {
          detour(pg, x, y, freedom);
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
   Holding the mouse pressed in the same location results in a growing light ball making the surroundings
   brighter and brighter.
   ####################################################################################################*/
  void paintAgain (int x, int y, int delay, int strokeW, color pColor, int freedom) {
    if (strokeW == 0)                //If user has selected eraser, just call the paint function
      this.paint(x, y, x+1, y+1, strokeW, pColor, freedom);
    else {
      color c = color(random(200, 255), random(200, 255), random(200, 255));
      PGraphics pg = createGraphics( this.width, this.height );
      pg.set(0, 0, this);
      pg.beginDraw();
      pg.noFill();
      pg.strokeWeight(3*delay/2);    //Points of varying (delay dependent) sizes and opacities are drawn
      pg.stroke(c, 5);               //Adding up to the final result
      pg.point( x, y );
      pg.strokeWeight(delay/2);
      pg.stroke(c, 5);
      pg.point( x, y );
      pg.strokeWeight(delay/3);
      pg.stroke(255, 5);
      pg.point( x, y );
      pg.strokeWeight(strokeW+3);
      pg.stroke(255);
      pg.point( x, y );
      if (random(100-8*freedom) < 1) {  //Probability driven addition of defects
        detour(pg, x, y, freedom);      //Defects are created in a separate function
      }
      pg.endDraw();
      pg.loadPixels();
      this.loadPixels();
      arrayCopy(pg.pixels, this.pixels);
      this.updatePixels();
    }
  }
  /* #################### Detour (defects) ############################################################
   Separate function called to add defects att position x, y
   ####################################################################################################*/
  void detour (PGraphics pg, int x, int y, int freedom) {
    color c = color(random(200, 255), random(200, 255), random(200, 255));
    pg.strokeWeight(1);
    pg.stroke(c, 70);
    float newX = 0;              //Variables to store positions of start and end of each curve
    float newY = 0;              //so the algorithm can draw connected curves through loops
    float endX = random(10, 20);
    float endY = random(-4, 4);
    pg.pushMatrix();
    pg.translate(x, y);
    pg.rotate(random(2*PI));
    for (int j = 0; j < freedom/2; j++) {   //Loops through drawing two curve segments per loop, number of loops depends on freedom parameter
      endX = newX + random(10, 100);        //Finds new end point
      endY = newY + random(-20, 20);
      pg.bezier(newX, newY, newX + random(4), newY + random(30, 40), endX+random(4), endY+random(30, 40), endX, endY);
      newX = endX - random(10, 100);        //Again finds new end point
      newY = endY - random(-20, 20);
      pg.bezier(endX, endY, endX-random(4), endY-random(30, 40), newX-random(4), newY-random(30, 40), newX, newY);
    }
    pg.strokeWeight(3);
    pg.stroke(c, 200);
    pg.point(newX, newY);                   //Finishes off with bright point at the end of the final curve
    pg.popMatrix();
  }
}

