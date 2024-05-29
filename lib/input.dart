part of threeengine;

class Input {
    List<bool> keysDown = List.filled(256, false);
    List<bool> keysPressed = List.filled(256, false);
    List<bool> buttons = List.filled(5, false);

    Vector2 mousePos = Vector2(0, 0);
    Vector2 mouseDelta = Vector2(0, 0);

    bool cursorLocked = false;
    bool debug = false;

    Input() {
      document.onKeyDown.listen(onKeyDown);
      document.onKeyUp.listen(onKeyUp);

      document.onMouseMove.listen(onMouseMove);

      document.onMouseDown.listen(onMouseDown);
      document.onMouseUp.listen(onMouseUp);
    }

    void printDebug() {
      debug = true;
    }

    void tick() {
      keysPressed.fillRange(0, keysDown.length, false);

      if(document.pointerLockElement == null) {
        cursorLocked = false;
      }
    }

    void onKeyDown(KeyboardEvent e) {
      if(e.keyCode < keysDown.length) {
        if (!keysPressed[e.keyCode]) {
          keysDown[e.keyCode] = true;
          keysPressed[e.keyCode] = true;
        }

        if(debug) print("Key down: ${e.keyCode}");
      }
    }

    void onKeyUp(KeyboardEvent e) {
      if(e.keyCode < keysDown.length) {
        keysDown[e.keyCode] = false;
        keysPressed[e.keyCode] = false;
      }
    }

    void setCursorLock(bool lock) {
      if(lock) {
        canvas.requestPointerLock();
      } else {
        document.exitPointerLock();
      }
      cursorLocked = lock;
    }

    void onMouseMove(MouseEvent e) {
      mouseDelta = Vector2(e.movement.x as double, e.movement.y as double);
      mousePos = Vector2(e.client.x as double, e.client.y as double);

      if(debug) print("Mouse Pos: $mousePos, Mouse Delta: $mouseDelta");
    }

    void onMouseDown(MouseEvent e) {
      if(e.button < buttons.length) {
        buttons[e.button] = true;

        if(debug) print("Mouse button down: ${e.button}");
      }
    }

    void onMouseUp(MouseEvent e) {
      if(e.button < buttons.length) {
        buttons[e.button] = false;
      }
    }
}
