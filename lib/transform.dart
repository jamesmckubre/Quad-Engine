part of threeengine;

class Transform {
  Matrix4 transformMatrix = Matrix4.identity();
  Matrix4 parentMatrix = Matrix4.identity();

  Vector3 pos = Vector3.zero();
  Quaternion rot = Quaternion.identity();
  Vector3 scale = Vector3.all(1.0);

  bool forceUpdate = false;

  Transform([Vector3? pos, Quaternion? rot, Vector3? scale]) {
    if(scale != null) {
      this.scale = scale;
    } else {
      this.scale = Vector3.all(1.0);
    }

    if(rot != null) {
      this.rot = rot;
    }else {
      this.rot = Quaternion(0, 0, 0, 1);
    }

    if(pos != null) {
      this.pos = pos;
    }else {
      this.pos = Vector3.zero();
    }

    transformMatrix.scale(1.0);
    transformMatrix.setRotation(Quaternion(0, 0, 0, 1).asRotationMatrix());
    transformMatrix.translate(0.0);

    forceUpdate = true;
  }

  void updateTransform() {
    if(forceUpdate) {
      transformMatrix.setTranslation(pos);
      transformMatrix.setRotation(rot.asRotationMatrix());
      transformMatrix.scale(scale.x, scale.y, scale.z);

      transformMatrix = parentMatrix.multiplied(transformMatrix);
      forceUpdate = false;
    }
  }

  void rotate(Vector3 axis, double angle) {
    rot = Quaternion.axisAngle(axis, angle)..asRotationMatrix().multiplied(rot.asRotationMatrix())..normalized();

    forceUpdate = true;
  }

  void position(Vector3 pos) {
    this.pos = pos;

    forceUpdate = true;
  }

  void move(Vector3 dir, double amt) {
    pos = pos..add(dir.clone()..scale(amt));

    forceUpdate = true;
  }

  void setParent(Transform parent) {
    parentMatrix = parent.transformMatrix;

    forceUpdate = true;
  }

  Transform fromMatrix(Matrix4 matrix) {
    transformMatrix = matrix.clone();
    return this;
  }

  Vector3 forward() {
    return rot.asRotationMatrix().forward;
  }
  Vector3 backward() {
    return forward().clone()..applyMatrix3(Matrix3.rotationY((Math.pi / 2.0)*2.0));
  }
  Vector3 left() {
    return forward().clone()..applyMatrix3(Matrix3.rotationY(-(Math.pi / 2.0)));
  }
  Vector3 right() {
    return forward().clone()..applyMatrix3(Matrix3.rotationY(Math.pi / 2.0));
  }
}
