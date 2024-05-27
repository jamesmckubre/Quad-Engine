part of threeengine;

class Screen {
  WebGL.RenderingContext gl;
  Camera camera;

  static List<int> colours = <int>[];

  static int renderingMode = RenderingMode.FULL_COLOR;

  late WebGL.UniformLocation worldTransformLocation, viewTransformLocation, projTransformLocation,screenTransformLocation, texTransformLocation;
  late WebGL.UniformLocation colorLocation1, colorLocation2, colorLocation3, colorLocation4;

  late int posLocation = gl.getAttribLocation(testShader.program, "a_pos");
  late int texLocation = gl.getAttribLocation(testShader.program, "a_tex");

  double scale = ((canvas.height as double) / (canvas.width as double));

  Screen(this.gl, this.camera) {
     for (int r = 0; r < 6; r++) {
         for (int g = 0; g < 6; g++) {
             for (int b = 0; b < 6; b++) {
                 int rr = (r * 255 ~/ 5);
                 int gg = (g * 255 ~/ 5);
                 int bb = (b * 255 ~/ 5);
                 colours.add(rr << 16 | gg << 8 | bb);
             }
         }
     }

    worldTransformLocation = gl.getUniformLocation(testShader.program, "u_world");
    viewTransformLocation = gl.getUniformLocation(testShader.program, "u_view");
    projTransformLocation = gl.getUniformLocation(testShader.program, "u_proj");

    texTransformLocation = gl.getUniformLocation(testShader.program, "u_text");

    colorLocation1 = gl.getUniformLocation(testShader.program, "u_col1");
    colorLocation2 = gl.getUniformLocation(testShader.program, "u_col2");
    colorLocation3 = gl.getUniformLocation(testShader.program, "u_col3");
    colorLocation4 = gl.getUniformLocation(testShader.program, "u_col4");

    Float32List vertexArray = Float32List(4*5);
    vertexArray.setAll(0*5, [-0.5, -0.5, 0.0, 1.0, 1.0]);
    vertexArray.setAll(1*5, [-0.5, 0.5, 0.0, 1.0, 0.0]);
    vertexArray.setAll(2*5, [0.5, 0.5, 0.0, 0.0, 0.0]);
    vertexArray.setAll(3*5, [0.5, -0.5, 0.0, 0.0, 1.0]);

    Int16List indexArray = Int16List(6);
    indexArray.setAll(0, [0, 1, 2, 0, 2, 3]);

    WebGL.Buffer vertexBuffer = gl.createBuffer();
    gl.bindBuffer(WebGL.WebGL.ARRAY_BUFFER, vertexBuffer);
    gl.bufferData(WebGL.WebGL.ARRAY_BUFFER, vertexArray, WebGL.WebGL.STATIC_DRAW);
    gl.vertexAttribPointer(posLocation, 3, WebGL.WebGL.FLOAT, false, 5 * Float32List.bytesPerElement, 0 * Float32List.bytesPerElement);
    gl.enableVertexAttribArray(posLocation);
    gl.vertexAttribPointer(texLocation,	2, WebGL.WebGL.FLOAT, false, 5 * Float32List.bytesPerElement, 3 * Float32List.bytesPerElement);
    gl.enableVertexAttribArray(texLocation);

    WebGL.Buffer indexBuffer = gl.createBuffer();
    gl.bindBuffer(WebGL.WebGL.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.bufferData(WebGL.WebGL.ELEMENT_ARRAY_BUFFER, indexArray, WebGL.WebGL.STATIC_DRAW);
  }

  void drawSprite(Sprite sprite, Transform transform) {
    if(!sprite.sheetTexture.loaded) return;

    transform.updateTransform();

    Vector3 distanceToCam = (transform.pos - camera.getTransform().pos)..absolute();
    if(distanceToCam.length > camera.drawDistance) return;

    gl.useProgram(testShader.program);
    gl.bindTexture(WebGL.WebGL.TEXTURE_2D, sprite.sheetTexture.texture);

    Matrix4 worldMatrix = transform.transformMatrix.clone();

    Matrix4 textureOffset = Matrix4.identity();
    if(sprite.textureSize.x != sprite.textureSize.y) {
      if(sprite.textureSize.y > sprite.textureSize.x) {
        worldMatrix.scale(1.0, 1.0 + (scale), 1.0);
      } else  if(sprite.textureSize.y < sprite.textureSize.x) {
        worldMatrix.scale(1.0, 1.0 - (scale), 1.0);
      }
    }

    textureOffset.scale(1.0 / sprite.sheetTexture.width,1.0 / sprite.sheetTexture.height, 0.0);
    textureOffset.translate(sprite.texturePos.x + 0.25, sprite.texturePos.y + 0.25, 0.0);
    textureOffset.scale((sprite.textureSize.x - 0.5), (sprite.textureSize.y - 0.5), 0.0);

    if(renderingMode == RenderingMode.SIX_BIT_COLOR) {
      if(sprite.colors != null) {
        int col = Util.getColor(sprite.colors!.x.toInt(), sprite.colors!.y.toInt(), sprite.colors!.z.toInt(), sprite.colors!.w.toInt());
        gl.uniform3fv(colorLocation1, Util.returnColor((col) & 255).storage);
        gl.uniform3fv(colorLocation2, Util.returnColor((col >> 8) & 255).storage);
        gl.uniform3fv(colorLocation3, Util.returnColor((col >> 16) & 255).storage);
        gl.uniform3fv(colorLocation4, Util.returnColor((col >> 24) & 255).storage);
      } else {
        throw "Sprite colors not set! ";
      }
    } else {
      gl.uniform3fv(colorLocation1, Vector3.all(-1).storage);
      gl.uniform3fv(colorLocation2, Vector3.all(-1).storage);
      gl.uniform3fv(colorLocation3, Vector3.all(-1).storage);
      gl.uniform3fv(colorLocation4, Vector3.all(-1).storage);
    }

    gl.uniformMatrix4fv(worldTransformLocation, false, worldMatrix.storage);
    gl.uniformMatrix4fv(viewTransformLocation, false, camera.viewMatrix.storage);
    gl.uniformMatrix4fv(projTransformLocation, false, camera.projMatrix.storage);
    gl.uniformMatrix4fv(texTransformLocation, false, textureOffset.storage);

    gl.drawElements(WebGL.WebGL.TRIANGLES, 6, WebGL.WebGL.UNSIGNED_SHORT, 0);
  }
}
