# Quad Engine

Quad Engine is a lightweight graphics rendering engine written in Dart. It is designed to efficiently render quads and utilizes an Entity-Component-System (ECS) architecture for managing entities and their behaviors.

## Features
- Quad Rendering: Efficient rendering of quads with customizable textures and transformations.
- Entity-Component-System (ECS): Utilizes an ECS architecture for flexible and scalable entity management.
- Modular Design: Designed with modularity in mind, making it easy to extend and customize for specific project needs.

## Installation
1. **Install Dart SDK:** If you haven't already, install the Dart SDK on your machine. You can download it from the Dart website and follow the installation instructions for your operating system.
2. **Clone Repository:** Clone the repository to your local machine.
```bash
git clone https://github.com/your_username/dart-graphics-engine.git
```
4. **Template:** Duplicate the template folder included in the repository and rename it. Open the ```pubspec.yaml``` file in your chosen text editor and change whats listed below in ```<>```
```yaml
name: <NAME OF PROJECT>
description: An absolute bare-bones web app.
version: 1.0.0

...

dependencies:
  quad_engine:
    path: <PATH TO LIBRARY DIRECTORY>

...
```
5. **Update Repository:** Lastly you must run the command ```dart pub update``` in your terminal or command line application.



## Usage
This is the contents of the template ```main.dart``` file. This is a basic empty scene with camera.


```dart
import 'package:enginepackage/quad_engine.dart';

class GameScene extends Scene {

  @override
  void init() {
    Camera camera = Camera(); // This is the camera component. Each scene requires a camera component.
    Entity cameraEntity = Entity(Transform()).addComponent(camera); // Create a entity to hold our camera component.
    cameraEntity.addComponent(MoveComponent()); // Adding a simple free move controller to the camera entity.
    addEntity(cameraEntity); // Add the camera entity to the scene.

    setSceneCamera(camera, 5.0); // Letting the scene know which camera should be active. Only one camera can be active at a time.
    setRenderingMode(RenderingMode.FULL_COLOR); // Telling the engine to draw all sprites at full colors as they are in the sprite sheet.

    print("hello world");
  }
}

void main() {
  Core().start(GameScene()); // The Core() function is called and the start(SCENE_NAME) lets the engine know where to start.
}
```
### Entities
Each entity has its own transform, which handles positioning and orientation in the world. Additionally, entities have a list of components, making them adaptable and specialized. These components cover various behaviors and attributes, like rendering properties and interactive features.

### Components
Components are essential elements defining entity behavior and attributes. The currently available components are:

- TagComponent: Allows for unique entity identification and referencing via designated string identifiers.
- SpriteComponent: Enables entities to effortlessly render sprites and textures onto the screen.
- MoveComponent: Provides basic movement control, allowing entities to navigate the environment using standard keyboard inputs (WASD for horizontal movement, space and shift for vertical movement).
- LookAtComponent: Empowers entities with dynamic orientation adjustment, ensuring they focus on specific positions within the environment.

Developers have the flexibility to create custom components to extend functionality further. A example custom component is below. This example component prints "hello world" on each update.
```dart
class ExampleComponent extends Component {

 ExampleComponent();

  @override
  void init() {
  }

  @override
  void update(Input input) {
    print("hello world");
  }

  @override
  void render(Screen screen) {
  }
}
```

## License

[MIT](https://choosealicense.com/licenses/mit/)
