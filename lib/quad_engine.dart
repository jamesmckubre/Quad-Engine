library threeengine;

import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as WebGL;
import 'package:vector_math/vector_math.dart';
import 'dart:math' as Math;

part 'transform.dart';
part 'input.dart';
part 'util.dart';

part 'screen.dart';
part 'shader.dart';
part 'sprite.dart';
part 'texture.dart';

part 'scene.dart';

part 'entity.dart';
part 'component.dart';

late WebGL.RenderingContext gl;
late CanvasElement canvas;

class Core {
  static bool fillScreen = false;

  late Camera camera;
  late Input input;
  late Screen screen;

  late Scene scene;

  void start(Scene scene) {
    canvas =  querySelector("#game") as CanvasElement;
    gl = canvas.getContext("webgl") as WebGL.RenderingContext;
    Util.initGl();

    Texture.loadAll();
    input = Input();

    this.scene = scene;
    scene.init();

    screen = Screen(gl, scene.camera);

    window.requestAnimationFrame(animate);
  }

  int lastTime = DateTime.now().millisecondsSinceEpoch;
  double unprocessedFrames = 0.0;

  void animate(num time) {
    int now = DateTime.now().millisecondsSinceEpoch;
    unprocessedFrames+=(now-lastTime)*60.0/1000.0;
    if(unprocessedFrames>10.0) unprocessedFrames = 10.0;
    while(unprocessedFrames > 1.0) {
      tick();
      unprocessedFrames -=1.0;
    }
    render();

    window.requestAnimationFrame(animate);
  }


  void tick() {
    input.tick();
    scene.sceneUpdate(input);
    scene.rootObject.updateAll(input);
  }

  void render() {
    Util.updateGl();
    scene.sceneRender(screen);
    scene.rootObject.renderAll(screen);
  }
}
