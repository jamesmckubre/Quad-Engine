part of threeengine;

class RenderingMode {
    static final int FULL_COLOR = 0;
    static final int SIX_BIT_COLOR = 1;
}

class Util {
  static void initGl() {
    if(gl == null) {
      gl = canvas.getContext('experimental-webgl') as WebGL.RenderingContext;
      if(gl == null) {
        print("No WebGL support");
        return;
      }
    }
    gl.enable(WebGL.WebGL.DEPTH_TEST);
    gl.depthFunc(WebGL.WebGL.LESS);

    // gl.enable(WebGL.WebGL.CULL_FACE);
    // gl.cullFace(WebGL.WebGL.BACK);

    gl.clearColor(0.75, 0.85, 0.8, 1.0);
    gl.clear(WebGL.WebGL.COLOR_BUFFER_BIT | WebGL.WebGL.DEPTH_BUFFER_BIT);
  }


  static void updateGl() {
    gl.viewport(0, 0, canvas.width as int, canvas.height as int);
    gl.clearColor(0.2, 0.2, 0.2, 1.0);
    gl.clear(WebGL.WebGL.COLOR_BUFFER_BIT | WebGL.WebGL.DEPTH_BUFFER_BIT);

  }

  static getColor(int colour1, int colour2, int colour3, int colour4) {
       return ((getInternal(colour4) << 24) + (getInternal(colour3) << 16) + (getInternal(colour2) << 8) + getInternal(colour1));
   }

   static getInternal(int colour) {
       if (colour < 0) return 255;
       int r = (colour / 100 % 10).toInt();
       int g = (colour / 10 % 10).toInt();
       int b = (colour % 10).toInt();
       int out = (r * 36 + g * 6 + b);
       return out;

   }

   static returnColor(int col) {
     int returnedCol = Screen.colours[col];
     int rr = (returnedCol >> 16) & 0xFF;
     int gg = (returnedCol >> 8) & 0xFF;
     int bb = returnedCol & 0xFF;

     return Vector3(rr / 255.0, gg / 255.0, bb / 255.0);
   }
}
