part of threeengine;

String vertexShaderText = """
precision highp float;

attribute vec3 a_pos;
attribute vec2 a_tex;

uniform mat4 u_world;
uniform mat4 u_view;
uniform mat4 u_proj;
uniform mat4 u_text;

varying vec2 v_tex;
varying float v_dist;

void main() {
  v_tex = (u_text *vec4(a_tex, 0.0, 1.0)).xy;
  vec4 pos = u_proj * u_view * u_world * vec4(a_pos, 1.0);
  v_dist = pos.z/10.0;
  gl_Position = pos;
}
""";

String fragmentShaderText = """
precision highp float;

uniform sampler2D u_tex;

uniform vec3 u_col1;
uniform vec3 u_col2;
uniform vec3 u_col3;
uniform vec3 u_col4;

varying vec2 v_tex;
varying float v_dist;

void main() {
  vec4 col = texture2D(u_tex, v_tex);

  vec3 col1 = vec3(0.0, 0.0, 0.0);
  vec3 col2 = vec3(81.0/255.0, 81.0/255.0, 81.0/255.0);
  vec3 col3 = vec3(173.0/255.0, 173.0/255.0, 173.0/255.0);
  vec3 col4 = vec3(255.0/255.0, 255.0/255.0, 255.0/255.0);

  if(u_col1.r != -1.0) {
    if(col1.r != -1.0 || col.g != -1.0 || col.b != -1.0) {
      if(col.rgb == col1) {
        col.rgb = u_col1;
      } else if(col.rgb == col2) {
        col.rgb = u_col2;
      } else if(col.rgb == col3) {
        col.rgb = u_col3;
      } else if(col.rgb == col4) {
        col.rgb = u_col4;
      } else {
        discard;
      }
    }
  }

  vec4 processedCol = col;

  if(processedCol.a > 0.0) {
    float fog = 1.0 - v_dist;
    fog = fog*fog*fog;
    gl_FragColor = vec4(processedCol.xyz * fog+vec3(0.2, 0.2, 0.2) * (1.0 -fog), 1.0);
  } else {
    discard;
  }
}
""";


Shader testShader = Shader(vertexShaderText, fragmentShaderText);

class Shader {

  late String vertexShaderSource, fragmentShaderSource;
  late WebGL.Shader vertexShader, fragmentShader;
  late WebGL.Program program;

  Shader(this.vertexShaderSource, this.fragmentShaderSource) {
    vertexShader = gl.createShader(WebGL.WebGL.VERTEX_SHADER);
    gl.shaderSource(vertexShader, vertexShaderSource);
    gl.compileShader(vertexShader);
    if(!(gl.getShaderParameter(vertexShader, WebGL.WebGL.COMPILE_STATUS) as bool)) {
      throw gl.getShaderInfoLog(vertexShader) as String;
    }

    fragmentShader = gl.createShader(WebGL.WebGL.FRAGMENT_SHADER);
    gl.shaderSource(fragmentShader, fragmentShaderSource);
    gl.compileShader(fragmentShader);
    if(!(gl.getShaderParameter(fragmentShader, WebGL.WebGL.COMPILE_STATUS) as bool)) {
      throw gl.getShaderInfoLog(fragmentShader) as String;
    }

    program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);

    if(!(gl.getProgramParameter(program, WebGL.WebGL.LINK_STATUS)as bool)) {
      throw gl.getProgramInfoLog(program) as String;
    }

    gl.validateProgram(program);
    if(!(gl.getProgramParameter(program, WebGL.WebGL.VALIDATE_STATUS)as bool)) {
      throw gl.getProgramInfoLog(program) as String;
    }
  }
}
