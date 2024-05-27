part of threeengine;

class Sprite {

  Texture sheetTexture;
  Vector4? colors;
  Vector2 texturePos, textureSize;

  Sprite(this.sheetTexture, this.texturePos, this.textureSize, [Vector4? colors]) {
    if(colors != null) {
      this.colors = colors;
    }
  }

}
