part of threeengine;

class Transform {
  Matrix4 transformMatrix = Matrix4.identity();
  Matrix4 parentMatrix = Matrix4.identity();

  Vector3 pos = Vector3.zero();
  Quaternion rot = Quaternion.identity();
  Vector3 scale = Vector3.all(1.0);

  bool forceUpdate = false;
  bool dontUseParent = false;

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
    forceUpdate = true;

    Quaternion rotationQuaternion = Quaternion.axisAngle(axis, angle);
    rot = rotationQuaternion * rot;

  }

  void position(Vector3 pos) {
    this.pos = pos;

    forceUpdate = true;
  }

  void move(Vector3 dir, double amt, [Vector3? frozenAxis]) {
    if(frozenAxis != null) {
      dir.x *= (1 - frozenAxis.x.abs());
      dir.y *= (1 - frozenAxis.y.abs());
      dir.z *= (1 - frozenAxis.z.abs());

      if (dir.length > 0) dir = dir.normalized();
    }

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

  Vector3 up() {
    return Vector3(0.0, 1.0, 0.0)..applyQuaternion(rot);
  }

  Vector3 forward() {
    return Vector3(0.0, 0.0, 1.0)..applyQuaternion(rot);
  }
  Vector3 backward() {
    return Vector3(0.0, 0.0, -1.0)..applyQuaternion(rot);
  }
  Vector3 left() {
    return Vector3(1.0, 0.0, 0.0)..applyQuaternion(rot);
  }
  Vector3 right() {
    return Vector3(-1.0, 0.0, 0.0)..applyQuaternion(rot);
  }
}
