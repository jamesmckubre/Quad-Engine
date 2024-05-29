part of threeengine;

class Entity {

  List<Entity> children = <Entity>[];
  List<Component> components = <Component>[];

  List<Entity> toDestroy = <Entity>[];

  Transform transform;
  late Entity parent;

  Entity(this.transform);

  Entity addChild(Entity child) {
    children.add(child);
    child.setParent(this);
    child.init();
    return this;
  }

  void setParent(Entity parent) {
    this.parent = parent;
    transform.setParent(parent.transform);
  }

  void markForDestruction() {
    parent.toDestroy.add(this);
  }

  Entity addComponent(Component component) {
    components.add(component);
    component.setParent(this);
    component.init();
    return this;
  }

  void init() {
    for(Component c in components) {
      c.init();
    }

    for(Entity e in children) {
      e.init();
    }

    transform.forceUpdate = true;
  }

  void updateAll(Input input) {
    update(input);

    for(Entity e in children) {
      e.updateAll(input);

      for(int i=0;i<toDestroy.length;i++) {
          if(toDestroy[i] == e) {
            toDestroy.remove(i);
            children.remove(e);

            print("destroyed");
          }
      }
    }
  }

  void renderAll(Screen screen) {
    render(screen);

    for(Entity e in children) {
      e.renderAll(screen);
    }
  }

  void update(Input input) {


    for(Component c in components) {
      c.update(input);
    }

    transform.updateTransform();
  }

  void render(Screen screen) {
    for(Component c in components) {
      c.render(screen);
    }
  }
}
