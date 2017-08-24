/*##################################################################################################
 Abstract class extending PImage to make sure that all transformation classes have the same functions
 available.
 Author: Carl Malmstroem
 SFUID:301294715
 ###################################################################################################*/

abstract class drawing extends PImage {
  abstract void paint (int x, int y, int px, int py, int penStroke, color lineColor, int freedom);
  abstract void paintAgain (int x, int y, int delay, int penStroke, color lineColor, int freedom);
}

