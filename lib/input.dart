part of threeengine;

class Input {
    List<bool> keysDown = List.filled(256, false);
    List<bool> keysPressed = List.filled(256, false);

    Input() {
      document.onKeyDown.listen(onKeyDown);
      document.onKeyUp.listen(onKeyUp);
    }

    void tick() {
      keysPressed.fillRange(0, keysDown.length, false);
    }

    void onKeyDown(KeyboardEvent e) {
      if(e.keyCode < keysDown.length) {
        if (!keysPressed[e.keyCode]) {
          keysDown[e.keyCode] = true;
          keysPressed[e.keyCode] = true;
        }
      }
    }

    void onKeyUp(KeyboardEvent e) {
      if(e.keyCode < keysDown.length) {
        keysDown[e.keyCode] = false;
        keysPressed[e.keyCode] = false;
      }
    }
}
