/*##################################################################################################
 Second application window to hold control panel
 Author: Carl Malmstroem
 SFUID:301294715
 ###################################################################################################*/

class PFrame extends Frame {
  public PFrame() {
    setBounds(100, 80, 300, 720);
    ctrl = new controlApplet();
    add(ctrl);
    ctrl.init();
    show();
  }
}

