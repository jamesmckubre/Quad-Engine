part of threeengine;

class Texture {
  static final List<Texture> _pendingTextures = <Texture>[];
  String url;
  late WebGL.Texture texture;
  late int width, height;
  late bool loaded = false;

  Texture(this.url) {
    if(gl==null) {
      _pendingTextures.add(this);
    } else {
      load();
    }
  }

  static void loadAll() {
    _pendingTextures.forEach((e)=>e.load());
    _pendingTextures.clear();
  }

  void load() {
    ImageElement img = ImageElement();
    texture = gl.createTexture();
    img.onLoad.listen((e) {
      gl.bindTexture(WebGL.WebGL.TEXTURE_2D, texture);
      gl.texImage2D(WebGL.WebGL.TEXTURE_2D, 0, WebGL.WebGL.RGBA, WebGL.WebGL.RGBA, WebGL.WebGL.UNSIGNED_BYTE, img);
      gl.texParameteri(WebGL.WebGL.TEXTURE_2D, WebGL.WebGL.TEXTURE_MIN_FILTER, WebGL.WebGL.NEAREST);
      gl.texParameteri(WebGL.WebGL.TEXTURE_2D, WebGL.WebGL.TEXTURE_MAG_FILTER, WebGL.WebGL.NEAREST);

      width = img.width as int;
      height = img.height as int;
      loaded = true;
    });
    img.src = url;
  }
}
