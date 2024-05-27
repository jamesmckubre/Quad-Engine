import 'package:quad_engine/quad_engine.dart';

class GameScene extends Scene {

  @override
  void init() {
    Camera camera = Camera(); // This is the camera component. Each scene requires a camera component.
    Entity cameraEntity = Entity(Transform()).addComponent(camera); // Create a entity to hold our camera component.
    cameraEntity.addComponent(MoveComponent()); // Adding a simple free move controller to the camera entity.
    addEntity(cameraEntity); // Add the camera entity to the scene.

    setSceneCamera(camera, 5.0); // Letting the scene know which camera should be active. Only one camera can be active at a time.
    setRenderingMode(RenderingMode.FULL_COLOR); // Telling the engine to draw all sprites at full colors as they are in the sprite sheet.
  }

}

void main() {
  Core().start(GameScene()); // The Core() function is called and the start(SCENE_NAME) lets the engine know where to start.
}
