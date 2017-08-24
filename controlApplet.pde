/*##################################################################################################
 Control panel for the application
 Author: Carl Malmstroem
 SFUID:301294715
 ###################################################################################################*/

class controlApplet extends PApplet {

  // #################### Fields ###################################################################
  PFont f;                //Large font
  PFont fs;               //Small font
  ControlP5 controls;
  RadioButton modeBtn;
  RadioButton penBtn;
  Button saveBtn;
  Button redoBtn;
  Button impBtn;
  Button clrBtn;
  Slider inkSld;
  Slider freeSld;
  // #################### Constructor ##############################################################
  void controlApplet() {
  }
  /* #################### Setup #######################################################################
   Set low frame rate as there is no need for higher in this window (it only needs to be responsive enough
   for mouse overs). Creates fonts and contructs all control elements.
   ####################################################################################################*/
  void setup() {
    size(300, 720);
    frameRate(10);
    noStroke();
    fill ( 0 );
    background( 240, 255 );
    f = createFont ("Arial", 24, false);
    fs = createFont ("Arial", 12, false);
    /* #################### Control elements ############################################################
     penBtn: Pen button. Default value: "Medium"
     inkSld: Pen ink slider. Default value: 100 (black)
     freeSld: Transformation freedom slider. Default value: 5
     modeBtn: Transformation mode button. Default value: "Basic sketch"
     redoBtn: Redo transformation button
     impBtn: Import image button
     clrBtn: Clear sketch button
     saveBtn: Save sketch button
     ####################################################################################################*/
    controls = new ControlP5(this);
    penBtn = controls.addRadioButton("penBtn")
      .setPosition(20, 60)
        .setSize(20, 20)
          .setColorLabel(color(0))
            .setColorActive(color(200))
              .setColorForeground(color(150)) 
                .setColorBackground(color(0)) 
                  .setItemsPerRow(3)
                    .setSpacingRow(20)
                      .setSpacingColumn(50)
                        .addItem("Fine", 1)
                          .addItem("Medium", 2)
                            .addItem("Coarse", 4)
                              .addItem("Eraser", 0)
                                .activate(1)
                                  ;

    inkSld = controls.addSlider("")
      .setPosition(20, 160)
        .setSize(160, 20)
          .setRange(10, 100)
            .setValue(100)
              .setColorForeground(color(0)) 
                .setColorActive(color(150))
                  .setColorBackground(color(200)) 
                    ;
    freeSld = controls.addSlider(" ")
      .setPosition(20, 260)
        .setSize(160, 20)
          .setRange(0, 10)
            .setValue(5)
              .setColorForeground(color(0)) 
                .setColorActive(color(150))
                  .setColorBackground(color(200)) 
                    ;
    modeBtn = controls.addRadioButton("mode")
      .setPosition(20, 300)
        .setSize(20, 20)
          .setColorLabel(color(0))
            .setColorActive(color(200))
              .setColorForeground(color(150)) 
                .setColorBackground(color(0)) 
                  .setItemsPerRow(2)
                    .setSpacingRow(20)
                      .setSpacingColumn(70)
                        .addItem("Basic sketch", 1)
                          .addItem("Fine lines", 2)
                            .addItem("Light paint", 3)
                              .addItem("Geometric", 4)
                                .activate(0)
                                  ;
    redoBtn = controls.addButton("redoBtn")
      .setCaptionLabel("Redo transformation")
        .setSize(240, 30)
          .setPosition(20, 380)
            .setColorActive(color(200))
              .setColorForeground(color(150)) 
                .setColorBackground(color(0))
                  ;
    impBtn = controls.addButton("impBtn")
      .setCaptionLabel("Import image")
        .setSize(240, 30)
          .setPosition(20, 480)
            .setColorActive(color(200))
              .setColorForeground(color(150)) 
                .setColorBackground(color(0))
                  ;
    clrBtn = controls.addButton("clrBtn")
      .setCaptionLabel("Clear sketch")
        .setSize(240, 30)
          .setPosition(20, 580)
            .setColorActive(color(200))
              .setColorForeground(color(150)) 
                .setColorBackground(color(0))
                  ;
    saveBtn = controls.addButton("saveBtn")
      .setCaptionLabel("Save")
        .setSize(240, 30)
          .setPosition(20, 630)
            .setColorActive(color(200))
              .setColorForeground(color(150)) 
                .setColorBackground(color(0))
                  ;
  }
  /* #################### Setup #######################################################################
   Draws the headers and instructions
   ####################################################################################################*/
  void draw() {
    background( 240, 255 );
    textFont (f, 24);            //Large font texts (headers)
    text("Drawing tools", 20, 30);
    text("Sketch transformation", 20, 230);
    textFont (fs, 12);          //Small font texts (instructions and details)
    text("Pencil type", 20, 50);
    text("Pencil ink", 20, 150);
    text("Freedom of transformation", 20, 250);
    text("Please have patience when applying", 20, 430);
    text("transformations, they might take a minute", 20, 445);
    text("To import an image, place it in the sketch's", 20, 530);
    text("data folder and name it 'input.jpg'.", 20, 545);
  }
  /* #################### Control element events ######################################################
   Listeners for the different buttons.
   controlEvent(): Is called for all events. This checks if the event is from an element that should
   change a variable in the main sketch and depending on the element calls the corresponding function
   in the main sketch passing the value generated by the event.
   saveBtn(), impBtn(), redoBtn(): Calls the correspoding function in the main sketch. Import button
   starts by first calling the clearBtn() function to clear the sketch.
   clearBtn(): Resets other elements to their default values and then calls the corresponding function
   in the main sketch.
   ####################################################################################################*/
  void controlEvent(ControlEvent event) {
    if (event.isFrom(penBtn)) {
      setStroke(int(event.getValue()));
    } else if (event.isFrom(modeBtn)) {
      updateSketch(int(event.getValue()));
    } else if (event.isFrom(inkSld)) {
      setColor(color(255-255*event.getValue()/100));
    } else if (event.isFrom(freeSld)) {
      setFreedom(int(event.getValue()));
    }
  } 
  void saveBtn() {
    saver();
  } 
  void clrBtn() {
    penBtn.activate(1);
    modeBtn.activate(0);
    inkSld.setValue(100);
    clearSketch();
  }
  void impBtn() {
    clrBtn();
    importImg();
  }
  void redoBtn() {
    updateSketch(int(modeBtn.getValue()));
  }
}

