part of threeengine;

class Component {
  late Entity parent;

  void init() {}
  void update(Input input) {}
  void render(Screen screen) {}

  void setParent(Entity parent) {
    this.parent = parent;
  }

  Transform getTransform() {
    return parent.transform;
  }
}

class Camera extends Component {
  late Matrix4 viewMatrix, projMatrix, projClippingMatrix;

  double fov, near, far;
  double drawDistance = 10.0;

  Camera([this.fov=70.0, this.near = 0.01, this.far=10.0]);

  @override
  void init() {
    viewMatrix = makeViewMatrix(getTransform().transformMatrix.getTranslation(), getTransform().transformMatrix.getRotation().forward, getTransform().transformMatrix.getRotation().up);
    projMatrix = makePerspectiveMatrix(fov * Math.pi/180, (canvas.width as int) / (canvas.height as int), near, far);
    projClippingMatrix = makeOrthographicMatrix(-10, 10, -10, 10, 0.1, 10.0);

  }

  @override
  void update(Input input) {
    Vector3 cameraLookPos = Vector3(getTransform().pos.x + getTransform().forward().x, getTransform().pos.y + getTransform().forward().y, getTransform().pos.z + getTransform().forward().z);
    viewMatrix = makeViewMatrix(getTransform().pos, cameraLookPos, Vector3(0.0, 1.0, 0.0));
  }
}

class TagComponent extends Component {
  String tag;

  TagComponent(this.tag);
}

class SpriteComponent extends Component {
  Sprite sprite;
  Transform? transform;

  SpriteComponent(this.sprite, [Transform? transform]) {
    if(transform != null) {
      this.transform = transform;
    }
  }

  @override
  void render(Screen screen) {
    transform = getTransform();
    screen.drawSprite(sprite,transform!);
  }
}

class MoveComponent extends Component {

    late double rot = 0.0;
    late double rotA = 0.0;
    double speed = 0.005;
    double rotSpeed = 0.001;

  MoveComponent();

  @override
  void update(Input input) {
    getTransform().rot.setEuler(rot, 0, 0);
    if(input.keysDown[65]) { // rotLeft
      rotA+=rotSpeed;
    }
    if(input.keysDown[68]) { // rotRight
      rotA-=rotSpeed;
    }

    if(input.keysDown[32]) {
      getTransform().move(Vector3(0, 1, 0), speed);
    }

    if(input.keysDown[16]) {
      getTransform().move(Vector3(0, -1, 0), speed);
    }

    if(input.keysDown[87] || input.keysDown[38]) { // up
      getTransform().move(getTransform().forward(), speed);
    }
    if(input.keysDown[83] || input.keysDown[40]) { // down
      getTransform().move(getTransform().forward(), -speed);
    }
    if(input.keysDown[81] || input.keysDown[37]) { // left
      getTransform().move(getTransform().left(), speed);
    }
    if(input.keysDown[69] || input.keysDown[39]) { //right
      getTransform().move(getTransform().right(), speed);
    }

    rot += rotA;
    rotA *= 0.9;
    getTransform().move(Vector3.zero(), 0.0);
  }
}

class LookAtComponent extends Component {
  Vector3 target;

  LookAtComponent(this.target);

  @override
  void update(Input input) {
    getTransform().transformMatrix.setRotation(makeViewMatrix(getTransform().pos, target, Vector3(0, 1, 0)).getRotation()..invert());

  }
}
