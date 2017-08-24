/*##################################################################################################
 File holding some basic image filter effects used to simplify imported images for use in the application
 Author: Carl Malmstroem
 SFUID:301294715
 ###################################################################################################*/

/* #################### Greyscale ###################################################################
 Changes the color of each pixel to the pixel's brightness, throwing away all color data.
 ####################################################################################################*/
PImage greyscale (PImage inputImg) {
  inputImg.loadPixels();
  for (int i=0; i<inputImg.pixels.length; i++) {
    inputImg.pixels[i] = color(brightness(inputImg.pixels[i]));
  }
  inputImg.updatePixels();
  return inputImg;
}

/* #################### Posterize ###################################################################
 Changes the color of each pixel to the bin limit of the color range bin it is located it.
 The bins are created by dividing the whole range (255) by the variable levels.
 ####################################################################################################*/
PImage posterize (PImage inputImg) {
  int levels = 10;
  inputImg.loadPixels();
  for (int i=0; i<inputImg.pixels.length; i++) {
    for (int j=1; j<= levels; j++) {
      if (inputImg.pixels[i] > color((j-1)*255/levels) && inputImg.pixels[i] < color(j*255/levels)) {
        if (j == 1)
          inputImg.pixels[i] = color(0);
        else
          inputImg.pixels[i] = color((j)*255/levels);
      }
    }
  }
  inputImg.updatePixels();
  return inputImg;
}

/* #################### Edge detect #################################################################
 Checks if a pixel has the same color as it's left and upper neighbour, and if that is the case sets
 the color of these neighbours to white. Then loops through this new image to place points at the
 pixels remaining colored to make them larger.
 ####################################################################################################*/
PImage edgeDetect (PImage inputImg) {
  inputImg.loadPixels();
  for (int i=inputImg.width; i<inputImg.pixels.length; i++) {
    if (inputImg.pixels[i] == inputImg.pixels[i-1] && inputImg.pixels[i] == inputImg.pixels[i-width]) {
      inputImg.pixels[i-1] = color(255);
      inputImg.pixels[i-width] = color(255);
    }
  }
  PGraphics pg = createGraphics( inputImg.width, inputImg.height );
  pg.loadPixels();
  for (int i = 0; i<pg.pixels.length; i++)
    pg.pixels[i] = color(255);
  pg.updatePixels();
  pg.beginDraw();
  pg.strokeWeight(3);
  for (int i=0; i<inputImg.pixels.length; i++) {
    if (inputImg.pixels[i] < color(255)) {
      int y = int(i/width);
      int x = i-y*width;
      pg.stroke(color(inputImg.pixels[i]));
      pg.point(x, y);
    }
  }
  pg.endDraw();
  pg.updatePixels();
  arrayCopy(pg.pixels, inputImg.pixels);
  inputImg.updatePixels();
  return inputImg;
}

