part of threeengine;

class Scene {

  Entity rootObject = Entity(Transform());
  late Camera camera;

  void init() {}
  void update(Input input) {}
  void render(Screen screen) {}

  void addEntity(Entity e) {
    rootObject.addChild(e);
  }

  void setSceneCamera(Camera camera, double drawDistance) {
    this.camera = camera;
    this.camera.drawDistance = drawDistance;
  }

  void setRenderingMode(int renderingMode) {
    Screen.renderingMode = renderingMode;
  }

  void sceneUpdate(Input input) {

  }

  void sceneRender(Screen screen) {

  }

}
