/*##################################################################################################
 This is a drawing tool that transforms simple greyscale sketches through various transformative algorithms.
 The base sketches are constructed from user mouse (or touch) input or through imported image files.
 The tool provides three different transformation algorithms to pass the base sketch through.
 These transformations are fine pencil sketching, light painting and geometric abstraction.
 The algorithms sources the base sketch and grow from there with somewhat user controllable randomness.  
 Author: Carl Malmstroem
 SFUID:301294715
 ###################################################################################################*/

// #################### Libraries ##################################################################
import java.awt.Frame;
import controlP5.*;

// #################### Global variables ###########################################################
PFrame controlWindow;          //Extra window for control panel
controlApplet ctrl;            //Applet for control panel, to run in controlWindow
drawing mainSketch;            //Holds the drawing that is to be displayed
lineSketch basicSketch;        //Holds the basic line sketch of the drawing
int mode = 1;                  //Varialbe for drawing mode (transformation), controlled in controlApplet
int freedom = 5;               //Used in random equations, higher value yields more uncertain result
int penStroke = 2;             //Width of pen stroke, controlled in controlApplet
int delay = 0;                 //Stores the delay (in frames) if the user holds the mouse still while pressing a button
color lineColor = color(0);    //User selected color to paint with  
boolean done = true;           //State of transformation
/* #################### Setup #######################################################################
 P2D renderer for increased performance. Initializes drawing variables through clearSketch() function 
 ####################################################################################################*/
void setup() {
  size( 1080, 720, P2D );
  background(255);
  clearSketch();
  controlWindow = new PFrame();
}
/* #################### Draw ########################################################################
 Only presents the sketch if transformation is done, as controlled by state variable. Added call to
 mouse event "held", if mouse is pressed but not moving
 ####################################################################################################*/
void draw() {
  background(255);
  if (done) 
    image( mainSketch, 0, 0 );
  if (mousePressed && pmouseX == mouseX && pmouseY == mouseY)
    mouseHeld();
}
/* #################### Mouse events ################################################################
 mouseMoved(): Change the mouse cursor to a cross to imply the actions in the drawing window
 mouseDragged(): Main drawing function. Resets delay (mouse is moving here) and calls the paint
 functions for both the basic and main sketch, this makes sure the basic sketch is updated
 and we don't need a fancy contructor for it to generate it all the time
 mouseHeld(): Added mouse event function to be used when mouse is pressed but not moving.
 Increments the delay and calls the paintAgain functions of both sketches
 mousePressed(): Resets delay. This is needed to avoid a paintAgain call with old delay value
 if user is holding the mouse in one position, releases the button and then holds it again 
 at a new position.
 ####################################################################################################*/
void mouseMoved() {
  cursor(CROSS);
}
void mouseDragged() {
  delay = 0;
  basicSketch.paint(mouseX, mouseY, pmouseX, pmouseY, penStroke, lineColor, freedom);
  mainSketch.paint(mouseX, mouseY, pmouseX, pmouseY, penStroke, lineColor, freedom);
}
void mouseHeld() {
  delay++;
  basicSketch.paintAgain(mouseX, mouseY, delay, penStroke, lineColor, freedom);
  mainSketch.paintAgain(mouseX, mouseY, delay, penStroke, lineColor, freedom);
}
void mousePressed() {
  delay = 0;
}
/* #################### Button events ###############################################################
 These are called from controlApplet when the user presses the different buttons and sliders.
 saver(): Saves the current drawing into output.png file.
 updateSketch(int): Updates the mode variable and generates a new main sketch based on this mode
 clearSketch(): Makes a new empty base sketch to start from scratch.
 importImg(): Imports input.jpg from sketch's data folder. Simplifies the image by passing it
 through greyscale, posterize and edge detect functions (located in imageEffects.pde) before
 setting it as base sketch.
 setStroke(int), setColor(color) and setFreedom(int): Updates the global variables according
 to input arguments.
 ####################################################################################################*/
void saver() {
  done = false;                      //Setting transformation state false and then true to produce a feedback effect
  PImage tempImage = createImage(mainSketch.width, mainSketch.height, ARGB);
  tempImage.set(0, 0, mainSketch);   //Need to generate a new PImage that is aware of the location of the application
  tempImage.save("output.png");
  done();
}
void updateSketch(int newMode) {
  mode = newMode;
  done = false;                      //Setting transformation state false. The constructors of the drawings will reset this
  switch(mode) {                     //when the transformation has been applied
  case 1:
    mainSketch = basicSketch;        //Basic sketch mode, no need to construct new sketch
    done();
    break;
  case 2:
    mainSketch = new fineLines( basicSketch, freedom );
    break;
  case 3:
    mainSketch = new lightPaint( basicSketch, freedom );
    break;
  case 4:
    mainSketch = new abstractGeo( basicSketch, freedom );
    break;
  }
}
void clearSketch() {
  basicSketch = new lineSketch( width, height );
  mainSketch = basicSketch;
}
void importImg() {
  File f = new File(dataPath("input.jpg"));     //Creates a file to check if input.jpg exists
  if (f.exists()) {
    PImage tempImage = loadImage("input.jpg");  //Loads new image so resize and filters can be applied before setting it as base sketch
    tempImage.resize(width, height);
    tempImage = greyscale(tempImage);
    tempImage = posterize(tempImage);
    tempImage = edgeDetect(tempImage);
    basicSketch.set(0, 0, tempImage);
  } else                                       //Error message if the file doesn't exist
  println("Can't locate image to import. Please place your image in JPG format inside this sketch's data folder and name it 'input'");
}
void setStroke(int newStroke) {
  penStroke = newStroke;
}
void setColor(color newColor) {
  lineColor = newColor;
}
void setFreedom(int newFree) {
  freedom = newFree;
}
// #################### Other events ################################################################
void done() {                //Function to call from drawing constructors when transformation is done
  done = true;
}

